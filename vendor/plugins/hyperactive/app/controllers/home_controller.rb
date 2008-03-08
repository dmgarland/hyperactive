class HomeController < ApplicationController

  # Rails does not pull out single-table inheritance subclasses properly on its own.
  # Must require the STI superclass explicitly in controllers.
  require_dependency 'content'    
  require_dependency 'post'
  
  featured_events = []
  
  def index
    @cloud = Tag.cloud
    @place_cloud = PlaceTag.cloud
    @events = Event.find(
      :all, 
      :conditions => ['hidden = ? and published = ? and promoted = ? and date >= ?', false, true, false, Date.today], 
      :order => 'date ASC',
      :page => {:size => objects_per_page, :current => page_param})
    @featured_events = Event.find(
      :all, 
      :limit => 3, 
      :order => "date ASC", 
      :conditions => ['hidden = ? and published = ? and promoted = ? and date >= ?', false, true, true, Date.today])
    @featured_videos = Video.find_where(:all, :order => 'created_on ASC', :limit => 5) do |video|
      video.processing_status == 2
      video.promoted == true
    end
    @featured_articles = Article.find(
      :all,
      :limit => 2,
      :order => "created_on DESC",
      :conditions => ['hidden = ? and published = ? and promoted = ?', false, true, true])
  end
  
end
