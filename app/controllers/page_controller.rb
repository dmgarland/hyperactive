class PageController < ApplicationController

  layout "two_column"

  def show
    @page = Page.find_by_title(params['title'])
  end
  
end
