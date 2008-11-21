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
    if (params[:search][:search_terms])
      @search_terms = params[:search][:search_terms]
      @articles = Article.find_with_ferret(@search_terms, {}, {:conditions => ['moderation_status != ?', "hidden"]})
      @events = Event.find_with_ferret(@search_terms, {}, {:conditions => ['moderation_status != ? AND date >= ?', "hidden", Date.today.to_s]})
      @videos = Video.find_with_ferret(@search_terms, {}, {:conditions => ['moderation_status != ?', "hidden"]})
      @collectives = Collective.find_with_ferret(@search_terms)
    end
  end

end