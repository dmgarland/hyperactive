class VideosController < ApplicationController
  
  layout "home"
  
  # Rails does not pull out single-table inheritance subclasses properly on its own.
  # Must require the STI superclass explicitly in controllers.
  require_dependency 'content'    
  require_dependency 'post'
  
  def create
    @video = Video.new(params[:video])
    respond_to do |format|
      if simple_captcha_valid? && @video.save
        @video.convert
        flash[:notice] = "Video was successfully created."
        format.html { redirect_to video_url(@video) }
        format.xml  { head :created, :location => video_url(@video) }
      else
        format.html { 
          @video.errors.add_to_base("You need to type the text from the image into the box so we know you're not a spambot.") unless (simple_captcha_valid?)
          render :action => "new" 
        }
        format.xml  { render :xml => @content.errors.to_xml }
      end
    end    
  end
  
  def destroy
    
  end
  
  def index
    @cloud = Tag.cloud
    @place_cloud = PlaceTag.cloud    
    @videos = Video.find_where(:all, :order => 'created_on DESC', :page => {:size => objects_per_page, :current => page_param}) do |content| 
    end         
    respond_to do |format|
      format.html # index.rhtml
      format.xml  { render :xml => @content.to_xml }
    end
  end  
  
  def list
    
  end
  
  def new
    @video = Video.new
  end

  def show
    @video = Video.find(params[:id])
  end
  
  def featured_in_player
    videos = Video.find(:all, :limit => 3, :order => 'created_on DESC')
    featured_vids = []
    videos.each do |video|
      featured_video = VideoSummary.new
      featured_video.title = video.title
      featured_video.id = video.id
      featured_video.file_path = "/system/video/file/#{video.file_relative_path}.small.jpg"
      featured_vids << featured_video
    end
    respond_to do |format|
      #@headers["Content-Type"] = 
      format.json {render :text => "vids=#{featured_vids.to_json}"}
    end
  end
  
end
