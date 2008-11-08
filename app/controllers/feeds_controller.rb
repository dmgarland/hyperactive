class FeedsController < ApplicationController
  
  layout 'two_column'

  def index
  end

  def action_alerts
    alerts = ActionAlert.find(:all, :order => 'created_on DESC', :limit => 20)
    construct_action_alerts_feed(alerts, "#{Hyperactive.site_name}: Action Alerts")
  end

  def latest_articles
    articles = Article.visible.find(:all, :order => 'created_on DESC', :limit => 20)
    construct_article_feed(articles, "#{Hyperactive.site_name}: Latest articles")
  end

  def latest_videos
    videos = Video.visible.find(:all, :order => 'created_on DESC', :limit => 20)
    construct_video_feed(videos, "#{Hyperactive.site_name}: Latest videos")
  end
  
  def upcoming_events
    events = Event.visible.upcoming.find(:all, 
       :order => 'date ASC', 
       :limit => events_per_feed)
    feedtitle = "#{Hyperactive.site_name}: Upcoming Events"
    construct_event_feed(events, feedtitle)
  end
  
  def upcoming_events_by_tag
    tagname = params[:scope]
    tag = Tag.find_by_name(tagname)
    if !tag.nil?
      events = tag.taggables.find(
        :all, 
        :conditions => ['moderation_status != ? and date >= ?', "hidden", Date.today],
        :limit => events_per_feed)
      feedtitle = "#{Hyperactive.site_name}: Upcoming Events Tagged With '#{tag.name}'"
      construct_event_feed(events, feedtitle)
    else 
      construct_event_feed([], feedtitle)
    end
  end
  
  def upcoming_events_by_place
    tagname = params[:scope]
    tag = PlaceTag.find_by_name(tagname)
    if !tag.nil?
      events = tag.place_taggables.find(
        :all, 
        :conditions => ['moderation_status != ? and date >= ?', "hidden", Date.today],
        :limit => events_per_feed)
      feedtitle = "#{Hyperactive.site_name}: Upcoming Events Tagged With '#{tag.name}"
      construct_event_feed(events, feedtitle)
    else
      construct_event_feed([], feedtitle)
    end
  end
    
  private
  
  def construct_action_alerts_feed(alerts, feedtitle)
    options = {:feed => {:title => feedtitle,
              :item => {:pub_date => :created_on },
              :link => {:controller => '/action_alerts', :action => 'list'}}
              }
    respond_to do |wants|
      wants.rss { render_rss_feed_for alerts, options }
      wants.atom { render_atom_feed_for alerts, options}
    end                  
  end
  
  def construct_article_feed(articles, feedtitle)
    options = {:feed => {:title => feedtitle,
              :item => {:pub_date => :created_on },
              :link => {:controller => 'articles', :action => 'show'}}
              }
    respond_to do |wants|
      wants.rss { render_rss_feed_for articles, options }
      wants.atom { render_atom_feed_for articles, options}
    end              
  end     
  
  
  def construct_event_feed(events,feedtitle)
    options = {:feed => {:title => feedtitle,
              :item => {:pub_date => :date },
              :link => {:controller => 'events', :action => 'show'}}
              }
    respond_to do |wants|
      wants.rss { render_rss_feed_for events, options }
      wants.atom { render_atom_feed_for events, options}
    end              
  end   
  
  def construct_video_feed(videos,feedtitle)
    options = {:feed => {:title => feedtitle,
               :id => "FOO",
              :item => {
                :pub_date => :date,
                :video_type => :video_type,
                :length => :media_size,
                :thumbnail => :thumbnail,
                :http_link => :relative_ogg_file,
                :torrent_link => :relative_torrent_file}
              }}
    respond_to do |wants|
      wants.atom { render_transmission_feed_for videos, options}
    end
  end   
  
end
