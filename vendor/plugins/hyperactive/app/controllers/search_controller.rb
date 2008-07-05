class SearchController < ApplicationController

  layout "two_column"
   
  def by_tag
    @tagname = params[:scope]
#    @date = (params[:date] ||= Date.today)
#    datestring = @date.to_s
    page = (params[:page] ||= 1).to_i
    @tag = Tag.find_by_name(@tagname)
    if !@tag.nil?
      @content = @tag.taggables.find(:all, 
#        :conditions => ['published = ? and hidden = ? and date >= ?', true, false, datestring],  
        :conditions => ['moderation_status != ?', "hidden"],  
        :order => "date ASC, title",
        :page => {:size => objects_per_page, :current => page}
        )
    end
    #@related_tags = Event.find_related_tags(@tag, :separator => ',')
  end

  def by_place_tag
    @tagname = params[:scope]
#    @date = (params[:date] ||= Date.today)
#    datestring = @date.to_s
    page = (params[:page] ||= 1).to_i
    @tag = PlaceTag.find_by_name(@tagname)
    if !@tag.nil?
      @content = @tag.place_taggables.find(:all, 
#      :conditions => ['published = ? and hidden = ? and date >= ?', true, false, datestring], 
      :conditions => ['moderation_status != ?', "hidden"],  
      :order => "date ASC, title",
      :page => {:size => objects_per_page, :current => page})
    end
  end

  def find_content
    if (params[:search])
      @search_terms = params[:search][:search_terms]
      @content = Content.paginating_ferret_search(:q => @search_terms,
        :page_size => objects_per_page, 
        :conditions => ['moderation_status != ?', "hidden"],  
        :current => page_param)
    end
  end

end