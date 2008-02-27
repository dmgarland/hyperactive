class PageController < ApplicationController

  layout "home"

  def show
    @page = Page.find_by_title(params['title'])
  end
  
end
