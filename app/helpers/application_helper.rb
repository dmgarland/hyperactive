# Methods added to this helper will be available to all templates in the application.
#
module ApplicationHelper

  def build_tag_cloud(tag_cloud, style_list)
    max, min = 0, 0
    tag_cloud.each do |tag|
      max = tag.popularity.to_i if tag.popularity.to_i > max
      min = tag.popularity.to_i if tag.popularity.to_i < min
    end
    divisor = ((max - min) / style_list.size) + 1
    tag_cloud.each do |tag|
      yield tag.name, style_list[(tag.popularity.to_i - min) / divisor]
    end
  end
  
  def default_content_for(name, &block)
    name = name.kind_of?(Symbol) ? ":#{name}" : name
    out = eval("yield #{name}", block.binding)
    concat(out || capture(&block))
  end  
  
  def css_from_plugin?
    if Hyperactive.use_local_css
      return nil
    else
      return 'hyperactive'
    end
  end  
  
  # Create a link to a tag's view page.
  def tag_item_path
    "/search/by_tag/"
  end
  
  def place_tag_item_path
    "/search/by_place_tag/"
  end
  
  def long_date(date)
    "#{date.strftime('%A %d %B %G %H:%M')}"
  end  
  
  
  # Builds navigation tabs 
  def tab_for(text, link, conditions = {})
    on = false
    if(!conditions[:controller_name].nil?)
      if(!conditions[:controller_name].nil?  && !conditions[:action_name].nil?)
        on = (@current_controller == conditions[:controller_name] && @current_action == conditions[:action_name])
      else 
        on = (@current_controller == conditions[:controller_name])
      end        
    end    
    
    if(!conditions[:slug].nil?)
      on = (params[:slug] == conditions[:slug])
    end
  
    content_tag :li, link_to(text, link), :class => ("current_page_item" if on), :id => "#{text.downcase.gsub(/ /, "")}-tab"
  end    

  def content_path_for(entity)
    if entity.class == Article
      article_path(entity)
    elsif entity.class == Event
      event_path(entity)
    elsif entity.class == Video
      video_path(entity)
    elsif entity.class == OtherMedia
      other_media_path(entity)
    end
  end
  
  def icon_image_for(entity)
    if entity.class == Article
      image_tag "icon_article.gif"
    elsif entity.class == Event
      image_tag "date.png"
    elsif entity.class == Video
      image_tag "icon_video.gif"
    elsif entity.class == OtherMedia
      image_tag "icons/world_link.png"  
    end    
  end  
  
  def moderation_status_icon_for(entity)
    if entity.moderation_status == "featured"
      image_tag "icons/star.png"
    elsif entity.moderation_status == "promoted"
      image_tag "icons/rosette.png"
    end    
  end    

  # A convenience method giving access to the thumbnail for this 
  # content object.
  #
  def thumbnail_for(entity)
    if entity.class == Video
      video_thumb = entity.file.url
      link_to(image_tag(video_thumb + ".small.jpg", :class => 'left'), entity)
    elsif entity.class == Article || entity.class == Event
      if entity.has_thumbnail?
        if entity.photos.length > 0
          link_to(image_tag(entity.photos.first.file.thumb.url, :class => 'left'), entity)
        elsif entity.contains_videos?
          video = entity.videos.first
          video_thumb = video.file.url
          link_to(image_tag(video_thumb + ".small.jpg", :class => 'left'), entity)          
        end
      end
    end
  end  
  
  def render_tag_list
    render(:partial => "shared/tag_list", :object=> @content.tag_list, :locals => {:tag_type => "tag"})
  end
  
  def render_place_tag_list
    render(:partial => "shared/tag_list", :object=> @content.place_tag_list, :locals => {:tag_type => "place"})
  end
  
  def page_links(list)
    render(:partial => "shared/pagination", :object => list)
  end
  
  
  # Same as thumbnail for but in a somewhat larger size.  Note that videos only
  # have one thumbnail size, so this will return the same thing as thumbnail_for 
  # for a video.
  # 
  def big_thumbnail_for(entity)
    if entity.class == Video
      video_thumb = entity.file
      link_to(image_tag(video_thumb + ".small.jpg", :class => 'left'), entity)
    elsif entity.class == Article || entity.class == Event
      if entity.has_thumbnail?
        if entity.photos.length > 0
          link_to(image_tag(entity.photos.first.file.big_thumb, :class => 'left'), entity)
        elsif entity.contains_videos?
          video = entity.videos.first
          video_thumb = video.file
          link_to(image_tag(video_thumb + ".small.jpg", :class => 'left'), entity)          
        end
      end
    end
  end  
  
  def collective_link_to(collective)
    render :partial => "shared/collectives/collective_link", :object => collective  
  end
  
  def render_subfeature(index)
    unless (@top_featured_articles.nil? || @top_featured_articles[index].nil?)
      render :partial => "home/subfeature", :locals => {:subfeature => @top_featured_articles[index]}
    end
  end

  def most_recent_event_with_image
    unless @recent_events.nil?
      @recent_events.each do |event|
        if event.has_thumbnail?
          return event
        end
      end
    end
    return nil
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
  
  def downcased_class_name(content)
    case content.class.to_s.humanize.downcase 
      when 'article'
        (I18n.t 'content.class_names.article').downcase
      when 'event'
        (I18n.t 'content.class_names.event').downcase
      when 'video'
        (I18n.t 'content.class_names.video').downcase
      when 'comment'
        (I18n.t 'content.class_name.comment').downcase
      when 'other media'
        (I18n.t 'content.class_names.other_media').downcase
    end 
  end
  
end
