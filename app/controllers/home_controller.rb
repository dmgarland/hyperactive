class HomeController < ApplicationController

  # Rails does not pull out single-table inheritance subclasses properly on its own.
  # Must require the STI superclass explicitly in controllers.
  require_dependency 'content'    
  require_dependency 'post'
  caches_page :index, :only_path => true
  
  featured_events = []
  
  def index
    @cloud = Tag.cloud(:limit => tags_in_cloud)
    @place_cloud = PlaceTag.cloud(:limit => tags_in_cloud)
    @featured_events = Event.find(
      :all, 
      :limit => 5, 
      :order => "date ASC", 
      :conditions => ['moderation_status = ? and date >= ?', "featured", Date.today])
    @recent_events = Event.find(
      :all, 
      :conditions => ['moderation_status = ? and date >= ?', "promoted", Date.today], 
      :order => 'date ASC',
      :limit => objects_per_page)
    @featured_videos = Video.find_where(:all, :order => 'created_on ASC', :limit => 5) do |video|
      video.processing_status == 2
      video.moderation_status == "featured"
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
    setup_action_alert
    @snippet = Snippet.find_by_key("homepage")
    feed_file = "#{RAILS_ROOT}/public/system/cache/uk_feed.rhtml"
    if File.exists?(feed_file)
      file = File.new(feed_file)
      @uk_feed = file.read
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
