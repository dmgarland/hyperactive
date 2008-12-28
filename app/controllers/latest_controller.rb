class LatestController < ApplicationController
  layout "two_column"

  def index
      # Get today's date
      # TODO: make the start_date a variable
      @date = Date.today + 1
      datestart = (@date - 8).to_s
      dateend = @date.to_s

      @content = Content.find(:all,
      :conditions => ['moderation_status != ? and updated_on >= ? and updated_on <= ?', "hidden", datestart, dateend])

      @comment = Comment.find(:all, 
      :conditions => ['moderation_status != ? and updated_on >= ? and updated_on <= ?','hidden', datestart, dateend])


      @all_content = @content + @comment
      @all_content.sort! {|y,x| x.updated_on <=> y.updated_on}

  end

end
