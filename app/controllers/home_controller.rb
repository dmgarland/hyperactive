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
    
    @featured_events = Event.featured.upcoming.all(:limit => 5, :order => "date ASC")
    @promoted_events = Event.promoted.upcoming.all(:limit => objects_per_page, :order => 'date ASC')
    @visible_events = Event.visible.upcoming.all(:limit => objects_per_page, :order => 'date ASC')
    
    @featured_videos = Video.featured.processed.all(:order => 'created_on ASC', :limit => 5)
    @featured_groups = Collective.frontpage 
    
    setup_featured_articles   
    @promoted_articles = Article.promoted.all(:limit => objects_per_page, :order => "created_on DESC")    
    @published_articles = Article.published.all(:limit => objects_per_page, :order => "created_on DESC")
    @featured_other_media = OtherMedia.featured.all(:limit => 6, :order => "created_on DESC")
    @promoted_other_media = OtherMedia.promoted.all(:limit => 6, :order => "created_on DESC")

    @pages = Page.show_on_front
    setup_action_alert
    @snippet = Snippet.find_by_key("homepage")
    @rightsnippet = Snippet.find_by_key("rightsnippet")
    feed_file = "#{RAILS_ROOT}/public/system/cache/feeds/home_page_feed.rhtml"
    if File.exists?(feed_file)
      file = File.new(feed_file)
      @home_page_feed = file.read
    end
  end
  
  protected
  
  def setup_featured_articles
    @top_article = Article.find(:first, :order => "created_on DESC", :conditions => ['stick_at_top = ? and moderation_status = ?', true, "featured"])
    if @top_article.nil?
      @top_article = Article.find(:first, :order => "created_on DESC", :conditions => ['moderation_status = ?', "featured"])
    end
    @top_featured_articles = Article.find(:all, :limit => 4, :order => "created_on DESC",
      :conditions => ["moderation_status = ? and id != ?", "featured",  @top_article.id]) unless @top_article.nil?
  end 
  
  # If there are currently any action alerts which are marked as showing up on the front page, 
  # get the most recent one so it can be inserted into the page.
  #
  def setup_action_alert
    @action_alert = ActionAlert.find(:first, :order => "created_on DESC", :conditions => ['on_front_page = ?', true])
  end
end
