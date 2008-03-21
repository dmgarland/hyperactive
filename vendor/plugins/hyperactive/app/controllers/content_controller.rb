class ContentController < ApplicationController

  layout "two_column"
  helper :date
  require 'calendar_dates/month_display.rb'
  require 'calendar_dates/week.rb'
  
  caches_page :show
  
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

  protected

  before_filter :can_edit?, :only => [:edit, :update]
  before_filter :can_destroy?, :only => [:destroy]

  def redisplay_publish_form
    prepare_photos
    prepare_videos
    prepare_links
    prepare_file_uploads
  end 
  
  def can_edit?
    return true if current_user.has_permission?("edit_all_content")  
    return true if current_user.has_permission?("edit_own_content")  && Event.find(params[:id]).user == current_user
    security_error
  end
  
  def can_destroy?
    return true if current_user.has_permission?("destroy")  
    security_error
  end
  
  def do_video_conversion
    if @content.videos.length > 0
      @content.videos.each do |video|
        video.convert
      end
    end
  end  
  
end