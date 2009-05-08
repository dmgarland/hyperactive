module ArchiveHelper
  def archive_title
    if @type == 'featured'
      I18n.t 'articles.list_featured.title' 
    elsif @type == 'promoted'
      I18n.t 'articles.list_promoted.title' 
    elsif @type == 'tag' && @tagname
      I18n.t('articles.list_tagged_as.title') + ' ' + @tagname
    elsif @type == 'place_tag' && @tagname
      I18n.t('articles.list_place_tagged_as.title') + ' ' + @tagname
    else
      I18n.t 'articles.index.title' 
    end
  end

  def render_archive_tag_list(article)
    render(:partial => "shared/archive_tag_list", :object=> article.tag_list, :locals => {:tag_type => "tag"})
  end
  
  def render_archive_place_tag_list(article)
    render(:partial => "shared/archive_tag_list", :object=> article.place_tag_list, :locals => {:tag_type => "place"})
  end

  def prev_month_link(start_date, type)
    prev_month = start_date << 1
    link_to "<< " + prev_month.strftime('%B %Y'), 
            :action => "month_index", 
            :year => prev_month.year, 
            :month => prev_month.month, 
            :type => type 
  end

  def next_month_link(start_date, type)
    next_month = start_date >> 1
    link_to next_month.strftime('%B %Y') + " >>",
            :action => "month_index", 
            :year => next_month.year, 
            :month => next_month.month, 
            :type => type 
  end

  def prev_year_link(year)
    prev_year = year - 1
    link_to "<< " + prev_year.to_s, :action => "year_index", :year => prev_year
  end
  
  def next_year_link(year)
    next_year = year + 1
    link_to next_year.to_s + " >>", :action => "year_index", :year => next_year
  end
  
end
