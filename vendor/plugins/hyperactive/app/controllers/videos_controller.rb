class VideosController < ContentController
  
  layout "two_column"
  
  # Rails does not pull out single-table inheritance subclasses properly on its own.
  # Must require the STI superclass explicitly in controllers.
  require_dependency 'content'    
  require_dependency 'post'
  
  def show
    @previous_videos = Video.find(:all, :conditions => ['hidden = ? and published = ? and id != ?', false, true, params[:id]], :limit => 5, :order => 'created_on DESC')
    @featured_videos = Video.find_where(:all, :order => 'created_on ASC', :limit => 5) do |video|
      video.processing_status == 2
      video.promoted == true
      video.published == true
    end
    super
  end
  
  def create
    @content = Video.new(params[:content])
    respond_to do |format|
      if simple_captcha_valid? && @content.save
        @content.tag_with params[:tags]
        @content.place_tag_with params[:place_tags]
        @content.convert
        flash[:notice] = "Video was successfully created."
        format.html { redirect_to video_url(@content) }
        format.xml  { head :created, :location => video_url(@content) }
      else
        format.html { 
          @content.errors.add_to_base("You need to type the text from the image into the box so we know you're not a spambot.") unless (simple_captcha_valid?)
          render :action => "new" 
        }
        format.xml  { render :xml => @content.errors.to_xml }
      end
    end    
  end
  
def update
    @content = model_class.find(params[:id])
    @content.update_attributes(params[:content])
    respond_to do |format|
      if @content.save
        @content.tag_with params[:tags]
        @content.place_tag_with params[:place_tags]
        @content.convert
        flash[:notice] = "Video was successfully updated."
        format.html { redirect_to video_url(@content) }
        format.xml  { head :created, :location => video_url(@content) }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @content.errors.to_xml }
      end
    end    
  end  
    
  def featured_in_player
    videos = Video.find_where(:all, :limit => 3, :order => 'created_on DESC') do |video|
      video.promoted == true
      video.processing_status == 2
    end
    featured_vids = []
    videos.each do |video|
      featured_video = VideoSummary.new
      featured_video.title = video.title
      featured_video.id = video.id
      featured_video.file_path = "/system/video/file/#{video.file_relative_path}.small.jpg"
      featured_vids << featured_video
    end
    respond_to do |format|
      format.json {render :text => "vids=#{featured_vids.to_json}"}
    end
  end
  
  protected
  
  def model_class
    Video
  end
  
  
end
