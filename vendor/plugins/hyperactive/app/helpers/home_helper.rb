module HomeHelper
    
  def render_subfeature(index)
    render :partial => "subfeature", :locals => {:subfeature => @top_featured_articles[index]} unless @top_featured_articles[index].nil?
  end
  
  def most_recent_promoted_event_with_image
    @featured_events.each do |event|
      if event.has_thumbnail?
        return event
      end
    end
  end
    
end
