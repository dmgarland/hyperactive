module HomeHelper
    
  def render_subfeature(index)
    unless (@top_featured_articles.nil? || @top_featured_articles[index].nil?)
      render :partial => "subfeature", :locals => {:subfeature => @top_featured_articles[index]}
    end
  end
  
  def most_recent_promoted_event_with_image
    unless @featured_events.nil?
      @featured_events.each do |event|
        if event.has_thumbnail?
          return event
        end
      end
    end
    return nil
  end
    
end
