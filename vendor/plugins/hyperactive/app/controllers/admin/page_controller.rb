class Admin::PageController < ApplicationController

  layout "two_column"

  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
    @pages = Page.find(
      :all, 
      :order => 'updated_on ASC',
      :page => {:size => objects_per_page, :current => page_param})
  end

  def show
    @page = Page.find(params[:id])
  end

  def new
    @page = Page.new
  end

  def create
    @page = Page.new(params[:page])
    if @page.save
      flash[:notice] = 'Page was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    @page = Page.find(params[:id])
  end

  def update
    @page = Page.find(params[:id])
    if @page.update_attributes(params[:page])
      flash[:notice] = 'Page was successfully updated.'
      redirect_to :action => 'show', :id => @page
    else
      render :action => 'edit'
    end
  end

  def destroy
    Page.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
  
  before_filter :protect_controller
  
  def protect_controller
    if !current_user.nil? and current_user.has_role?("Admin")
      return true
    else
      redirect_to "/publish/list"
      flash[:notice] = "You are not allowed to access this page."
    end
  end  
  
end
