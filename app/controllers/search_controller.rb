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
      @articles = ActsAsXapian::Search.new([Article], @search_terms, :limit => 20).results.collect {|r| r[:model]}
      @events = ActsAsXapian::Search.new([Event], @search_terms, :limit => 20).results.collect {|r| r[:model]}
      @videos = ActsAsXapian::Search.new([Video], @search_terms, :limit => 20).results.collect {|r| r[:model]}
      @collectives = ActsAsXapian::Search.new([Collective], @search_terms, :limit => 20).results.collect {|r| r[:model]}
    end
  end

end