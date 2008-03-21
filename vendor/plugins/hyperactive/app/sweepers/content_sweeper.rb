class ContentSweeper < ActionController::Caching::Sweeper
  
  observe Content
  
  def after_create(content)
    expire_home_page
  end

  def after_update(content)
    expire_home_page
    expire_cache_for(content)
  end
  
  def after_destroy(content)
    expire_home_page
    expire_cache_for(content)
  end
  
  private

  def expire_home_page
    expire_page(:controller => 'home', :action => 'index')
  end
  
  def expire_cache_for(content)
    expire_page(:controller => content.class.downcase.to_s.pluralize, :action => 'show', :id => content.id)
  end
  
end