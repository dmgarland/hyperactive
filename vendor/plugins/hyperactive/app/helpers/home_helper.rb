module HomeHelper
  
  def first_featured_article
    first_article = @featured_articles.slice(0)
    return [first_article]
  end
  
  def render_subfeature(index)
    render :partial => "subfeature", :locals => {:subfeature => @featured_articles[index]} unless @featured_articles[index].nil?
  end
  
  def subfeatures_column_two
    subfeatures_articles = @featured_articles.slice(3..4)
    return [subfeatures_articles]
  end
  
end
