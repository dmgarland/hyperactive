class VideosSweeper < ContentSweeper
  
  observe Video
  
  def after_create(content)
    expire_featured_videos
    super
  end

  def after_update(content)
    expire_featured_videos
    super
  end
  
  def after_destroy(content)
    expire_featured_videos
    super
  end
  
  private

  def expire_featured_videos
    expire_page(:controller => 'videos', :action => 'featured_in_player')
  end
  
end