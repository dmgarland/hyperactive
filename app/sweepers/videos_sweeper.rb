# Wipes out the static html files which are cached on disk whenever a Video 
# is added or hidden.
#
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

  # The featured_in_player method returns JSON which can be consumed by the 
  # Flash component to show a list of featured videos.  If videos get updated,
  # this JSON needs to be expired.
  def expire_featured_videos
    expire_page(:controller => 'videos', :action => 'featured_in_player')
  end
  

  
end