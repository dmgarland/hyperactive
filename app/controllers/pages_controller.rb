class PagesController < ApplicationController

  layout "two_column"

  def show
    @page = Page.find(params[:id])
    raise ActiveRecord::RecordNotFound if @page == nil
  end
  
end
