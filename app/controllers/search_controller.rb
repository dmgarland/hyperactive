class SearchController < ApplicationController

  layout "two_column"
  
  ssl_required :find_content
  
  def by_tag
    @tagname = params[:scope]
    @tag = Tag.find_by_name(@tagname)
    if !@tag.nil?
      @content = @tag.taggables.paginate(:all, 
        :conditions => ['moderation_status != ?', "hidden"],  
        :order => "created_on DESC, title",
        :page => page_param)
    end
  end

  def by_place_tag
    @tagname = params[:scope]
    @tag = PlaceTag.find_by_name(@tagname)
    if !@tag.nil?
      @content = @tag.place_taggables.paginate(:all, 
      :conditions => ['moderation_status != ?', "hidden"],  
      :order => "created_on DESC, title",
      :page => page_param)
    end
  end

  def find_content
    unless (params[:search].blank? || params[:search][:search_terms].blank?)
      @search_terms = params[:search][:search_terms]
      @articles = Article.visible.find_with_xapian(@search_terms)
      @events = Event.visible.find_with_xapian(@search_terms)
      @videos = Video.visible.find_with_xapian(@search_terms)
      @collectives = Collective.find_with_xapian(@search_terms)
    end
  end

end