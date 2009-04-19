class MonthlyArchiveController < ApplicationController
  layout "two_column"

  def index
    @oldest_content = Content.find(:first,
          :conditions => ['moderation_status != ?', "hidden"],
          :order      => 'created_on')
    @oldest_date = @oldest_content.created_on
    @oldest_date = Date.new(@oldest_date.year, @oldest_date.month, 1)
    @now = Date.today

    @months = []
    while @oldest_date <= @now
      @months << @oldest_date
      @oldest_date = @oldest_date >> 1
    end
    @months = @months.reverse
  end

  def month_index 
    @year = params[:year].to_i
    @month = params[:month].to_i
    
    @datestart = Date.new(@year, @month, 1)
    @dateend = Date.new(@year, @month, -1)

    @content = Content.find(:all,
    :conditions => ['moderation_status != ? and created_on >= ? and created_on <= ?', "hidden", @datestart, @dateend])

  end

end
