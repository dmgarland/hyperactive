class FeedsController < ApplicationController
  
  layout 'two_column'

  def index
  end

  def action_alerts
    @alerts = ActionAlert.find(:all, :order => 'created_on DESC', :limit => 20)
    response.headers['Content-Type'] = 'application/rss+xml'
    render :action => 'action_alerts', :layout => false    
  end

  def latest_articles
    @articles = Article.promoted_and_featured.find(:all, :order => 'created_on DESC', :limit => 20)
    response.headers['Content-Type'] = 'application/rss+xml'
    render :action => 'latest_articles', :layout => false 
  end

  def latest_videos
    @videos = Video.promoted_and_featured.find(:all, :order => 'created_on DESC', :limit => 20)
    response.headers['Content-Type'] = 'application/rss+xml'
    render :action => 'latest_videos', :layout => false 
  end
  
  def upcoming_events           
    @events = Event.promoted_and_featured.upcoming.find(:all, :order => 'date ASC', 
    :limit => events_per_feed)
    
    response.headers['Content-Type'] = 'application/rss+xml'
    render :action => 'upcoming_events', :layout => false
  end
  
  def upcoming_events_by_tag
    tagname = params[:scope]
    @tag = Tag.find_by_name(tagname)
    
    if !@tag.nil?
      @events = @tag.taggables.find(
        :all, 
        :conditions => ['moderation_status != ? and date >= ?', "hidden", Date.today],
        :limit => events_per_feed)
      response.headers['Content-Type'] = 'application/rss+xml'
      render :action => 'upcoming_events_by_tag', :layout => false
    else
      flash[:notice] = 'No events tagged ' + tagname + ' were found...'
      render :action => "index"
    end

  end
  
  def upcoming_events_by_place
    tagname = params[:scope]
    @tag = PlaceTag.find_by_name(tagname)

    if !@tag.nil?
      @events = @tag.place_taggables.find(
        :all, 
        :conditions => ['moderation_status != ? and date >= ?', "hidden", Date.today],
        :limit => events_per_feed)
      response.headers['Content-Type'] = 'application/rss+xml'
      render :action => 'upcoming_events_by_place', :layout => false
    else
      flash[:notice] = 'No events in ' + tagname + ' were found...'
      render :action => "index"
    end
  end

end
