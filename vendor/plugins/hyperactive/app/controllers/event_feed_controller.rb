class EventFeedController < ApplicationController

  def upcoming
    events = Event.find(:all, 
       :conditions => ['published = ? and hidden = ? and date >= ?', true, false, Date.today],
       :order => 'created_on ASC', 
       :limit => events_per_feed)
    feedtitle = "#{SITE_NAME}: Upcoming Events"
    construct_feed(events, feedtitle)
  end
  
  def upcoming_tagged
    tagname = params[:scope]
    tag = Tag.find_by_name(tagname)
    if !tag.nil?
      events = tag.taggables.find(
        :all, 
        :conditions => ['published = ? and hidden = ? and date >= ?', true, false, Date.today],
        :limit => events_per_feed)
    end
    feedtitle = "#{SITE_NAME}: Upcoming Events Tagged With '#{tag.name}'"
    construct_feed(events, feedtitle)
  end
  
  def upcoming_place
    tagname = params[:scope]
    tag = PlaceTag.find_by_name(tagname)
    if !tag.nil?
      events = tag.place_taggables.find(
        :all, 
        :conditions => ['published = ? and hidden = ? and date >= ?', true, false, Date.today],
        :limit => events_per_feed)
    end
    feedtitle = "#{SITE_NAME}: Upcoming Events Tagged With '#{tag.name}"
    construct_feed(events, feedtitle)
  end
  
  def construct_feed(events,feedtitle)
    options = {:feed => {:title => "IMC-UK: #{feedtitle}",
              :item => {:pub_date => :date },
              :link => {:controller => 'events', :action => 'show'}}
              }
    respond_to do |wants|
      wants.rss { render_rss_feed_for events, options }
      wants.atom { render_atom_feed_for events, options}
    end              

  end
  


end
