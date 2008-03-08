class TimelineController < ApplicationController

  require 'timeline_event'
  layout 'one_column'
  
  def show_calendar
    # find all the events that are active
    events = Event.find(:all, :events,  :conditions => ['hidden = ? and published =?', false, true], :limit => 100)
    timeline_events = []
    
    # convert them into the format expected by the timeline
    events.each do |event|
      timeline_event = TimelineEvent.new
      timeline_event.title = event.title.gsub(/</, "").gsub(/>/, "")
      # what we want is e.g.: "May 28 2006 09:00:00 GMT"
      timeline_event.start = event.date.strftime("%b %d %Y")
      timeline_event.description = event.summary.gsub(/</, "").gsub(/>/, "")  + "<p><a href='" + url_for(:controller => 'events', :action => 'show', :id => event) + "'>view full event</a></p>"
      if event.photos.length > 0
        photo = event.photos.first
        puts event.id
        timeline_event.image = url_for(base_url, :only_path => false) + "photo/file/" + photo.file_relative_path("thumb")
      end
      if event.end_date
        timeline_event.end = event.end_date.strftime("%b %d %Y")
      end
      timeline_events << timeline_event
    end
    
    # make sure not to send html but text/plain
    headers["Content-Type"] = "text/plain; charset=utf-8" 
    data = {  :datetime_format => 'iso8601', 
              :events => timeline_events
           }
    render_text data.to_json
  end

end

