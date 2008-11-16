# Wipes out the static html files which are cached on disk whenever Content 
# is added, edited or destroyed.
#
class ContentSweeper < ActionController::Caching::Sweeper
  
  observe ActionAlert, Content, Page, Snippet
  
  def after_create(content)
    expire_home_page
    expire_index_page_for(content)
    expire_cache_for_content_related_to(content) if content.is_a?(Content)
  end

  def after_update(content)
    expire_home_page
    expire_index_page_for(content)
    expire_cache_for(content) if content.is_a?(Content)
    expire_cache_for_content_related_to(content) if content.is_a?(Content) 
  end
  
  def after_destroy(content)
    expire_home_page
    expire_index_page_for(content)
    expire_cache_for(content) if content.is_a?(Content)
    expire_cache_for_content_related_to(content) if content.is_a?(Content)      
  end
  
  private
 
  # When any content is created, updated, or deleted, we should refresh the 
  # cache of the index page in case the content shows up there.
  #
  def expire_index_page_for(content)
    expire_page(:controller => content.class.to_s.downcase.pluralize, :action => 'index')
  end

  # When any content is created, updated, or deleted, we should refresh the
  # cache of the home page in case the content is on the home page.
  #
  def expire_home_page
    expire_page(root_path)
  end  
  
  # Expire the cache for the content show page.  
  #
  def expire_cache_for(content)
    expire_page(:controller => content.class.to_s.downcase.pluralize, :action => 'show', :id => content.id)
  end
  
  # If the content being affected is attached to or contains other content, 
  # we need to expire the cache for the article, event, or video(s).
  #
  def expire_cache_for_content_related_to(content)
    if content.has_related_content?
      expire_page(:controller => content.related_content.class.to_s.downcase.pluralize, :action => 'show', :id => content.related_content.id)
    end
    if content.is_a?(Post) && content.contains_videos?
      content.videos.each do |video|
        expire_page(:controller => 'videos', :action => 'show', :id => video.id)
      end
    end
  end  
  
end