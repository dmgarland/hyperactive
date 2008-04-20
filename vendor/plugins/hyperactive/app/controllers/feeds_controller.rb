class FeedsController < ApplicationController
  
  layout 'two_column'

  def index
  end

  def latest_articles
    articles = Article.find(:all, :order => 'created_on DESC', :limit => 20)
    construct_article_feed(articles, "#{SITE_NAME}: Latest articles")
  end

  def latest_videos
    videos = Video.find(:all, :order => 'created_on DESC', :limit => 20)
    construct_video_feed(videos, "#{SITE_NAME}: Latest videos")
  end
  
  def upcoming_events
    events = Event.find(:all, 
       :conditions => ['moderation_status = ? and date >= ?', "published", Date.today],
       :order => 'date ASC', 
       :limit => events_per_feed)
    feedtitle = "#{SITE_NAME}: Upcoming Events"
    construct_event_feed(events, feedtitle)
  end
  
  def upcoming_events_by_tag
    tagname = params[:scope]
    tag = Tag.find_by_name(tagname)
    if !tag.nil?
      events = tag.taggables.find(
        :all, 
        :conditions => ['moderation_status = ? and date >= ?', "published", Date.today],
        :limit => events_per_feed)
      feedtitle = "#{SITE_NAME}: Upcoming Events Tagged With '#{tag.name}'"
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
        :conditions => ['moderation_status = ? and date >= ?', "published", Date.today],
        :limit => events_per_feed)
      feedtitle = "#{SITE_NAME}: Upcoming Events Tagged With '#{tag.name}"
      construct_event_feed(events, feedtitle)
    else
      construct_event_feed([], feedtitle)
    end
  end
    
  private
  
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
                :length => :file_size,
                :thumbnail => :thumbnail,
                :http_link => :relative_ogg_file,
                :torrent_link => :relative_torrent_file}
              }}
    respond_to do |wants|
      wants.atom { render_transmission_feed_for videos, options}
    end
  end   
  
end
