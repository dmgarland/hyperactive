class ContentController < ApplicationController

  layout "two_column"
  helper :date
  require 'calendar_dates/month_display.rb'
  require 'calendar_dates/week.rb'
  
  caches_page :show
  cache_sweeper :content_sweeper, :only => [:create, :update, :destroy]
  cache_sweeper :comment_sweeper, :only => [:create_comment]
  
  # Rails does not pull out single-table inheritance subclasses properly on its own.
  # Must require the STI superclass explicitly in controllers.
  require_dependency 'content'    
  require_dependency 'post'
  
  include UIEnhancements::SubList
  helper :SubList
  
  sub_list 'Photo', 'content' do |photo|
  end
  
  sub_list 'Video', 'content' do |video|
  end

  sub_list 'FileUpload', 'content' do |file_upload|
  end
  
  sub_list 'Link', 'content' do |link|
  end
  
  def index
    @cloud = Tag.cloud
    @place_cloud = PlaceTag.cloud
    @content = model_class.find(
      :all,  
      :conditions => ['hidden = ? and published =?', false, true], 
      :order => 'created_on desc', 
      :page => {:size => objects_per_page, :current => page_param})
  end

  def list_promoted
    if model_class == Event
      order_string = 'date DESC'
    else 
      order_string = 'created_on DESC'
    end
    @content = model_class.find(
      :all, 
      :conditions => ['hidden = ? and published = ? and promoted = ?', false, true,true],
      
      :order => order_string,
      :page => {:size => objects_per_page, :current => page_param})
  end  

  def show
    @content = model_class.find(params[:id])
    @related_content = @content.more_like_this({:field_names => [ :title, :summary, :body ]}, {:conditions => ['hidden = ? and published = ?', false, true], :order_by => 'title asc', :limit => 5})
    if model_class == Event
      @date = @content.date.strftime("%Y-%m-%d")
    end
    @comment = Comment.new
    # @related_tags = Event.find_related_tags(@event.tag_names.to_s, :separator => ',')
  end  

    
  def new
    @content = model_class.new
  end

  def create
    @content = model_class.new(params[:content])
    @content.user = current_user if !current_user.is_anonymous?
    if(model_class == Event)
      check_end_date
    end
    success = true
    success &&= initialize_photos
    success &&= initialize_videos
    success &&= initialize_links
    success &&= initialize_file_uploads
    success &&= simple_captcha_valid? 
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
  end

  def update
    @content = model_class.find(params[:id])
    @content.update_attributes(params[:content])
    if(model_class == Event)
      check_end_date
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
    @comment = Comment.new(params[:comment])
    if @comment.valid? && simple_captcha_valid?
      @content.comments << @comment
      flash[:notice] = "Your comment has been added."
      redirect_to :action => 'show', :id => @content
    else
      @comment.errors.add_to_base("You need to type the text from the image into the box so we know you're not a spambot.") unless (simple_captcha_valid?)      
      render :action => 'show'
    end
  end
  
  def show_comment_form
    @content = model_class.find(params[:id])
    render :partial => "shared/content/comments/form",:layout => false
  end

  protected

  before_filter :can_edit?, :only => [:edit, :update]
  before_filter :can_destroy?, :only => [:destroy]

  def redisplay_publish_form
    prepare_photos
    prepare_videos
    prepare_links
    prepare_file_uploads
  end 
  
  # Checks permissions and ownership to see if a given user can edit content.
  #
  def can_edit?
    return true if current_user.has_permission?("edit_all_content")  
    return true if current_user.has_permission?("edit_own_content")  && Event.find(params[:id]).user == current_user
    security_error
  end
  
  # Checks permissions to see if the current user can destroy content.
  #
  def can_destroy?
    return true if current_user.has_permission?("destroy")  
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
  
  # Tricky.  Checks throught the incoming params[:video] hash, selects an array
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