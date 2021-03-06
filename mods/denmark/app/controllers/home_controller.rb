class HomeController < ApplicationController
  
  def index
    fucker
    @cloud = Tag.cloud(:limit => tags_in_cloud)
    @place_cloud = PlaceTag.cloud(:limit => tags_in_cloud)
    @featured_events = Event.featured.upcoming.all(:limit => 5, :order => "date ASC")
    @recent_events = Event.visible.upcoming.all(:limit => objects_per_page, :order => 'date ASC')
    @featured_videos = Video.featured.processed.all(:order => 'created_on ASC', :limit => 5)
    @featured_groups = Collective.frontpage 
    @recent_articles = Article.visible.all(:limit => 30, :order => "created_on DESC")
    @pages = Page.show_on_front
    setup_featured_articles
    setup_action_alert
    @snippet = Snippet.find_by_key("homepage")
    feed_file = "#{RAILS_ROOT}/public/system/cache/feeds/home_page_feed.rhtml"
    if File.exists?(feed_file)
      file = File.new(feed_file)
      @home_page_feed = file.read
    end
  end

end
