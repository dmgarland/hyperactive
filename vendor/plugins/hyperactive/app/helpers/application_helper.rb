# Methods added to this helper will be available to all templates in the application.
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
    concat(out || capture(&block), block.binding)
  end    
  
  # Create a link to a tag's view page.
  def tag_item_url
    "/search/by_tag/"
  end
  
  def place_tag_item_url
    "/search/by_place_tag/"
  end
  
  def long_date(date)
    "#{date.strftime('%A %B %d, %G')}"
  end
  
  def editable_by?(user, event)
    current_user.has_permission?("edit_all_content") || (current_user.has_permission?("edit_own_content") && event.user == current_user)
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
  
    content_tag :li, link_to(text, link), :class => ("current_page_item" if on)
  end    
  
  def content_url_for(entity)
    if entity.is_a?(Article)
      article_url(entity)
    elsif entity.is_a?(Event)
      event_url(entity)
    elsif entity.is_a?(Video)
      video_url(entity)
    end
  end
  
  def icon_image_for(entity)
    if entity.is_a?(Article)
      image_tag "icon_article.gif", :plugin => 'hyperactive'
    elsif entity.is_a?(Event)
      image_tag "date.png", :plugin => 'hyperactive'
    elsif entity.is_a?(Video)
      image_tag "icon_video.gif", :plugin => 'hyperactive'
    elsif entity.is_a?(Page)
      image_tag "icon_post.gif", :plugin => 'hyperactive'
    end    
  end  
  
  # A convenience method giving access to the thumbnail for this 
  # content object.
  #
  def thumbnail_for(entity)
    if entity.class == Video
      video_thumb = url_for_file_column(entity, "file")
      link_to(image_tag(video_thumb + ".small.jpg", :class => 'left'), entity)
    elsif entity.class == Article || entity.class == Event
      if entity.has_thumbnail?
        if entity.photos.length > 0
          link_to(image_tag(url_for_file_column(entity.photos.first, "file", "thumb"), :class => 'left'), entity)
        elsif entity.contains_videos?
          video = entity.videos.first
          video_thumb = url_for_file_column(video, "file")
          link_to(image_tag(video_thumb + ".small.jpg", :class => 'left'), entity)          
        end
      end
    end
  end  

  # Same as thumbnail for but in a somewhat larger size.  Note that videos only
  # have one thumbnail size, so this will return the same thing as thumbnail_for 
  # for a video.
  # 
  def big_thumbnail_for(entity)
    if entity.class == Video
      video_thumb = url_for_file_column(entity, "file")
      link_to(image_tag(video_thumb + ".small.jpg", :class => 'left'), entity)
    elsif entity.class == Article || entity.class == Event
      if entity.has_thumbnail?
        if entity.photos.length > 0
          link_to(image_tag(url_for_file_column(entity.photos.first, "file", "big_thumb"), :class => 'left'), entity)
        elsif entity.contains_videos?
          video = entity.videos.first
          video_thumb = url_for_file_column(video, "file")
          link_to(image_tag(video_thumb + ".small.jpg", :class => 'left'), entity)          
        end
      end
    end
  end  

end
