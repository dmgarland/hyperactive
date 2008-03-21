class ArticleSweeper < ActionController::Caching::Sweeper
  
  observe Article
  
  def after_create(article)
    expire_home_page
  end

  def after_update(article)
    expire_home_page
    expire_article_page(article)
  end
  
  private

  def expire_home_page
    expire_page(:controller => 'home', :action => 'index')
  end
  
  def expire_article_page(article)
    expire_page(article_url(article))
  end
  
end