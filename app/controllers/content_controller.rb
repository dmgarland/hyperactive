# A controller superclass for most of the content-related stuff on the site.
# Other controllers, such as ArticlesController, EventsController, and VideosController,
# get most of their functionality from here, overriding it as necessary.
#
# Note that instead of concrete models for CRUD operations, this controller uses
# "model_class".  This is defined in each of the subclasses.  This controller should
# never be hit directly, and there are no routes to hit it.
#
class ContentController < ApplicationController

  # Security filters
  #
  before_filter :can_edit?, :only => [:edit, :update]
  before_filter :can_destroy?, :only => [:destroy]
  
  uses_tiny_mce(:options => {:theme => 'advanced',
                           :browsers => %w{msie gecko safari opera},
                           :theme_advanced_toolbar_location => "top",
                           :theme_advanced_toolbar_align => "left",
                           :theme_advanced_statusbar_location => "bottom",
                           :theme_advanced_resizing => true,
                           :theme_advanced_resize_horizontal => false,
                           :theme_advanced_resizing_use_cookie => true,
                           :paste_auto_cleanup_on_paste => true,
                           :theme_advanced_buttons1 => %w{undo redo separator bold italic underline strikethrough separator bullist numlist separator link unlink separator cleanup code},
                           :theme_advanced_buttons2 => [],
                           :theme_advanced_buttons3 => [],
                           :plugins => %w{paste},
                           :valid_elements => Hyperactive.valid_elements_for_tiny_mce},
              :only => [:new, :edit, :create, :update])  


  layout "two_column"
  helper :date
  require 'calendar_dates/month_display.rb'
  require 'calendar_dates/week.rb'
  
  caches_page :show, :only_path => true
  caches_page :index
  cache_sweeper :content_sweeper, :only => [:create, :update, :destroy]
  cache_sweeper :comment_sweeper, :only => [:create_comment]
  
  # Rails does not pull out single-table inheritance subclasses properly on its own.
  # Must require the STI superclass explicitly in controllers.
  require_dependency 'content'    
  require_dependency 'post'
  require_dependency 'collective'
  
  include UIEnhancements::SubList
  helper :SubList

  # Require SSL for certain actions, mostly having to do with form submissions
  #
  ssl_required :create, :update, :destroy, :new, :edit, :add_photo, :add_file_upload, :add_video, :add_link, :create_comment, :show_comment_form
  
  # Note: this is a specially hacked sub_list which properly assigns the 
  # content to the parent subclass.
  #
  sub_list 'Photo', 'content', 'post' do |photo|
  end
  
  sub_list 'Video', 'content', 'post' do |video|
  end

  sub_list 'FileUpload', 'content', 'post' do |file_upload|
  end
  
  sub_list 'Link', 'content' do |link|
  end
  
  def index
    @cloud = Tag.cloud(:limit => 20)
    @content = model_class.paginate(
      :conditions => ['moderation_status != ?', "hidden"], 
      :order => 'created_on desc', 
      :page => page_param)
  end
  
  def archives
    @cloud = Tag.cloud(:limit => 20)
    @content = model_class.paginate(
      :conditions => ['moderation_status != ?', "hidden"], 
      :order => 'created_on desc', 
      :page => page_param)
  end

  def list_promoted
    if model_class == Event
      order_string = 'date DESC'
    else 
      order_string = 'created_on DESC'
    end
    @content = model_class.paginate(
      :conditions => ['moderation_status = ?', "promoted"],     
      :order => order_string,
      :page => page_param)
  end  
  
  def list_featured
    if model_class == Event
      order_string = 'date DESC'
    else 
      order_string = 'created_on DESC'
    end
    @content = model_class.paginate(
      :conditions => ['moderation_status = ?', "featured"],     
      :order => order_string,
      :page => page_param)
  end    

  def show
    @content = model_class.find(params[:id])
    @related_content = ActsAsXapian::Similar.new([model_class], [@content], :limit => 5).results.collect {|r| r[:model]}
    if model_class == Event
      @date = @content.date.strftime("%Y-%m-%d")
    end
    @comment = Comment.new
    # @related_tags = Event.find_related_tags(@event.tag_names.to_s, :separator => ',')
  end  

    
  def new
    @content = model_class.new
  end
  
  # Creates a content object.  Note that all of the "initialize_xxx" stuff halfway
  # through this method refers to the sub_list plugin, which provides multiple-upload
  # capabilities for us. See that plugin's documentation to learn more.
  #
  def create
    @content = model_class.new(params[:content])
    @content.set_moderation_status(params[:content][:moderation_status], current_user) 
    @content.user = current_user if !current_user.is_anonymous?
    if(model_class == Event)
      check_end_date
    end
    unless params[:open_street_map_info].blank?
      @open_street_map_info = OpenStreetMapInfo.new(params[:open_street_map_info]) 
      @content.open_street_map_info = @open_street_map_info
    end
    success = true
    success &&= initialize_photos
    success &&= initialize_videos
    success &&= initialize_links
    success &&= initialize_file_uploads
    success &&= !current_user.is_anonymous? || simple_captcha_valid? 
    if success && @content.save
        @content.tag_with params[:tags]
        @content.place_tag_with params[:place_tags]
        do_video_conversion
      if(model_class == Event)
        @content.update_all_taggings_with_date
        check_event_group
      end
      flash[:notice] = "#{model_class.to_s} was successfully created."
      redirect_to :action => 'show', :id => @content
    else
      redisplay_publish_form  
      @content.errors.add_to_base("You need to type the text from the image into the box so we know you're not a spambot.") unless (simple_captcha_valid?)
      render :action => 'new'
    end
  end
  
  def edit
    @content = model_class.find(params[:id])
    @open_street_map_info = @content.open_street_map_info
  end

  # Updates the content.  Note that we set the collective ids to an empty array, if the form sent
  # any collective ids then they'll be updated in the update_attributes line;  if not, we assume that
  # the user wants the content in no collectives.  This is a somewhat dangerous action and shouldn't
  # be called from anywhere that doesn't have the grouping controls enabled - it'll reset the 
  # collectives that the content is in unless it gets params[:content][:collective_ids]
  #
  # Note that all of the "initialize_xxx" stuff halfway
  # through this method refers to the sub_list plugin, which provides multiple-upload
  # capabilities for us. See that plugin's documentation to learn more.
  #
  def update
    @content = model_class.find(params[:id])
    #@content.collective_ids = [] 
    @content.update_attributes(params[:content])  
    @content.set_moderation_status(params[:content][:moderation_status], current_user)
    if(model_class == Event)
      check_end_date
    end
    if params[:open_street_map_info].blank?
      @content.open_street_map_info = nil
    else
      @open_street_map_info = OpenStreetMapInfo.new(params[:open_street_map_info]) 
      @content.open_street_map_info = @open_street_map_info
    end    
    success = true
    success &&= initialize_photos
    success &&= initialize_videos
    success &&= initialize_file_uploads
    success &&= initialize_links 
    success &&= @content.save    
    if success
      @content.tag_with params[:tags]
      @content.place_tag_with params[:place_tags]
      do_video_conversion
      if(model_class == Event)  
        @content.update_all_taggings_with_date
      end
      flash[:notice] = "#{model_class.to_s} was successfully updated."
      redirect_to :action => 'show', :id => @content
    else
      redisplay_publish_form
      render :action => 'edit'
    end
  end

  def destroy
    @content = model_class.find(params[:id])
    @content.destroy
    redirect_to :action => 'index'
  end
  
  def create_comment
    @content = Content.find(params[:id])
    if @content.allows_comments?
      @comment = Comment.new(params[:comment])
      if @comment.valid? && (!current_user.is_anonymous? || simple_captcha_valid?)
        @content.comments << @comment
        flash[:notice] = "Your comment has been added."
        redirect_to :action => 'show', :id => @content
      else
        @comment.errors.add_to_base("You need to type the text from the image into the box so we know you're not a spambot.") unless (simple_captcha_valid?)      
        render :template => 'shared/content/comments/form'
      end
    else
      flash[:notice] = "Comments are not allowed for this #{@content.class.to_s.downcase.humanize}"
      redirect_to :action => 'show', :id => @content
    end
  end
  
  def show_comment_form
    @comment = Comment.new
    @content = model_class.find(params[:id])
    render :template => "shared/content/comments/form"# ,:layout => false
  end

  # Retrieves the administration controls allowing a user to either hide or report a 
  # piece of content if it sucks.
  #
  def admin_controls
    @id = params[:id]
    if current_user.has_permission?("hide") || current_user.has_permission?("edit_own_content") || current_user.has_permission?("edit_all_content")
      @content = Content.find(@id)
      render :partial => 'shared/content/admin_controls', :layout => false
    else
      render :partial => 'hidden/report_this_controls', :layout => false
    end
  end
  
  # Retrieves the open street map controls.  We do it this way so that users can be informed
  # that they're about to use an external service
  #
  def show_map_controls
    @content = Content.find(params[:id])
    render :partial => 'shared/content/maps/open_street_map_info_show_controls'
  end

  protected

  def redisplay_publish_form
    prepare_photos
    prepare_videos
    prepare_links
    prepare_file_uploads
  end 
  
  # Checks permissions and ownership to see if a given user can edit content.
  # The first two success cases are pretty self-explanatory: the user can edit 
  # the content if he/she has got the correct permissions.
  #
  # The third success case is more interesting:  the user can edit the content if 
  # the user and the content share at least one collective in common.
  #
  def can_edit?
    return true if current_user.can_edit?(Content.find(params[:id]))
    security_error
  end
  
  # Checks permissions to see if the current user can destroy content.
  #
  def can_destroy?
    return true if current_user.can_destroy?(Content.find(params[:id]))
    security_error
  end
  
  # Tells uploaded videos to convert themselves using ffmpeg.
  #
  def do_video_conversion
    videos_to_convert = find_videos_needing_conversion
    if videos_to_convert.length > 0
      videos_to_convert.each do |video|
        video.convert
      end
    end
  end  
  
  # Tricky.  Checks through the incoming params[:video] hash, selects an array
  # of :ids for uploaded video objects which contain a file, and then selects
  # objects from the @content.videos array which correspond to those :ids, or which 
  # have a processing_status of nil (meaning they are new).
  #
  # Note that this is all necessary because we actually have two arrays, one of which
  # is the incoming params[:video].values from the form, and the other of which consists
  # of video objects attached to the @content.
  #
  def find_videos_needing_conversion
    uploaded_videos = params[:video].to_a
    uploaded_videos_with_file = uploaded_videos.select {|uploaded_video| uploaded_video[1][:file].class != StringIO && uploaded_video[1][:file].class != String }
    video_ids_to_convert = uploaded_videos_with_file.map {|uvwf| uvwf.first.to_i}
    videos_needing_conversion = @content.videos.select do |video|
      video_ids_to_convert.include?(video.id) || video.processing_status.nil?
    end
    return videos_needing_conversion
  end
  
end