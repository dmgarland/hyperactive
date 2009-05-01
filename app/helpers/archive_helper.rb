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
  
end
