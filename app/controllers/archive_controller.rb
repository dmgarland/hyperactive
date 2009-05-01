class ArchiveController < ApplicationController
  layout "two_column"

  caches_page :show, :only_path => true
  caches_page :index, :year_index, :month_index

  def index
    @oldest_date = get_oldest_date()
    @oldest_date = Date.new(@oldest_date.year, @oldest_date.month, 1)
    @now = Date.today

    @month_count = create_month_count_list @oldest_date, @now
  end

  def year_index
    @year = params[:year].to_i
    @start_date = get_oldest_date()
    @start_date = Date.new(@start_date.year, @start_date.month, 1)
    @end_date = Date.today
    if @start_date.year < @year
      @start_date = Date.new(@year, 1, 1)
    end
    if @end_date.year > @year
      @end_date = Date.new(@year, 12, 1)
    end
    @month_count = create_month_count_list @start_date, @end_date
  end

  def month_index 
    year = params[:year].to_i
    month = params[:month].to_i
    @start_date = Date.new(year, month, 1)
    @end_date = Date.new(year, month, -1)
    @type = params[:type]

    if @type == 'featured'
      conds = ['moderation_status = ? and created_on >= ? and created_on <= ?',
               'featured', @start_date, @end_date]
    elsif @type == 'promoted'
      conds = ['moderation_status = ? and created_on >= ? and created_on <= ?',
               'promoted', @start_date, @end_date]
    else 
      conds = ['moderation_status != ? and created_on >= ? and created_on <= ?',
               'hidden', @start_date, @end_date]
      if @type == 'tag'
        @showtags = true
      end
    end

    @all_content = Article.find(:all, :conditions => conds)
  end

  def tag_index 
    year = params[:year].to_i
    month = params[:month].to_i
    @start_date = Date.new(year, month, 1)
    @end_date = Date.new(year, month, -1)
    @showtags = true
    if !params[:place_tag].nil?
      @type = 'place_tag'
      @tagname = params[:place_tag]
      @tag = PlaceTag.find_by_name(@tagname)
    else
      @type = 'tag'
      @tagname = params[:tag]
      @tag = Tag.find_by_name(@tagname)
    end
    
    if @tag.nil?
      # if tag is blank, just show tags
      @all_content = Article.find(:all,
                      :conditions => ['moderation_status != ? and created_on >= ? and created_on <= ?', 'hidden', @start_date, @end_date])
    elsif @type == 'tag'
      @all_content = @tag.taggables.find(
        :all, 
        :conditions => ['moderation_status != ? and created_on >= ? and created_on <= ?', 
          "hidden", @start_date, @end_date],
        :order => "created_on DESC")
    else
      @all_content = @tag.place_taggables.find(
        :all, 
        :conditions => ['moderation_status != ? and created_on >= ? and created_on <= ?', 
          "hidden", @start_date, @end_date],
        :order => "created_on DESC")
    end
    render :template => "archive/month_index"
  end

  def this_month
    redirect_to :action => 'month_index', 
      :year => Date.today.year, 
      :month => Date.today.month,
      :type => params[:type]
  end

  private

  def get_oldest_date
    @oldest_content = Content.find(:first,
          :conditions => ['moderation_status != ?', "hidden"],
          :order      => 'created_on')
    return @oldest_content.created_on
  end

  def create_month_list(start_date, end_date)
    months = []
    while end_date >= start_date
      months << end_date
      end_date = end_date << 1
    end
    return months
  end

  def create_month_count_list(start_date, end_date)
    months = create_month_list(start_date, end_date)
    month_count = []
    for month in months
      month_start = Date.new(month.year, month.month, 1)
      month_end = Date.new(month.year, month.month, -1)
      count = Article.count(:conditions => ['moderation_status != ? and created_on >= ? and created_on <= ?', 
                            "hidden", month_start, month_end])
      month_count << {:month => month, :count => count}
    end
    return month_count
  end
end
