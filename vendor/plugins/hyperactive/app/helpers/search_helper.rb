module SearchHelper
  
  def content_url_for(entity)
    if entity.class == Article
      article_url(entity)
    elsif entity.class == Event
      event_url(entity)
    end
  end
  
  def icon_image_for(entity)
    if entity.class == Article
      image_tag "icon_article.gif"
    elsif entity.class == Event
      image_tag "date.png"
    end    
  end
  
end
