class HomeController < ApplicationController

  # Rails does not pull out single-table inheritance subclasses properly on its own.
  # Must require the STI superclass explicitly in controllers.
  require_dependency 'content'    
  require_dependency 'post'
  caches_page :index
  
  featured_events = []
  
  def index
    @cloud = Tag.cloud(:limit => tags_in_cloud)
    @place_cloud = PlaceTag.cloud(:limit => tags_in_cloud)
    @featured_events = Event.find(
      :all, 
      :limit => 5, 
      :order => "date ASC", 
      :conditions => ['moderation_status = ? and date >= ?', "promoted", Date.today])
    @recent_events = Event.find(
      :all, 
      :conditions => ['moderation_status = ? and date >= ?', "published", Date.today], 
      :order => 'date ASC',
      :limit => objects_per_page)
    @recent_videos = Video.find_where(:all, :order => 'created_on ASC', :limit => 5) do |video|
      video.processing_status == 2
      video.moderation_status == "published"
    end
    @featured_videos = Video.find_where(:all, :order => 'created_on ASC', :limit => 5) do |video|
      video.processing_status == 2
      video.moderation_status == "promoted"
    end    
    @recent_articles = Article.find(
      :all,
      :limit => objects_per_page,
      :order => "created_on DESC",
      :conditions => ['moderation_status = ?', "published"])
    @pages = Page.find(:all, :order => "title DESC")
    @promoted_articles = Article.find(:all, :limit => objects_per_page, :order => "created_on DESC",
      :conditions => ["moderation_status = ?", "promoted"])   
    setup_featured_articles
  end
  
  protected
  
  # TODO: it's gross that the @top_article is an array, make a new view partial for this
  # so we can get rid of this.  The front page probably should use something other than 
  # shared/content/list_summary or whatever it's using anyway.
  #
  def setup_featured_articles
    @top_article = Article.find(:first, :order => "created_on DESC", :conditions => ['stick_at_top = ? and moderation_status = ?', true, "featured"])
    if @top_article.nil?
      @top_article = Article.find(:first, :order => "created_on DESC", :conditions => ['moderation_status = ?', "featured"])
    end
    @top_featured_articles = Article.find(:all, :limit => 4, :order => "created_on DESC",
      :conditions => ["moderation_status = ? and id != ?", "featured",  @top_article.id]) unless @top_article.nil?
    @featured_articles = Article.find(:all, :limit => objects_per_page, :offset => 4, :order => "created_on DESC",
      :conditions => ["moderation_status = ? and id != ?", "featured",  @top_article.id]) unless @top_article.nil?
  end 
end
