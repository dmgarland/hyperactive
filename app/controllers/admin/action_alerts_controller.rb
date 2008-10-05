class Admin::ActionAlertsController < ApplicationController

  cache_sweeper :content_sweeper, :only => [:create, :update, :destroy]
  before_filter :protect_controller
 
  layout "admin"

  uses_tiny_mce(:options => {:theme => 'advanced',
                           :browsers => %w{msie gecko safari opera},
                           :theme_advanced_toolbar_location => "top",
                           :theme_advanced_toolbar_align => "left",
                           :theme_advanced_statusbar_location => "bottom",
                           :theme_advanced_resizing => true,
                           :theme_advanced_resize_horizontal => false,
                           :theme_advanced_resizing_use_cookie => true,
                           :paste_auto_cleanup_on_paste => true,
                           :theme_advanced_buttons1 => %w{undo redo separator bold italic underline strikethrough separator bullist numlist separator link unlink separator cleanup code},
                           :theme_advanced_buttons2 => [],
                           :theme_advanced_buttons3 => [],
                           :plugins => %w{paste cleanup}},
              :only => [:new, :edit, :create, :update, :preview]) 

  include SslRequirement
  ssl_required :all

  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
    @action_alerts = ActionAlert.find(
      :all, 
      :order => 'updated_on ASC',
      :page => {:size => objects_per_page, :current => page_param})
  end
  
  def preview
    @action_alert = ActionAlert.new(params[:action_alert])
  end

  def show
    @action_alert = ActionAlert.find(params[:id])
  end

  def new
    @action_alert = ActionAlert.new
  end

  def create
    @action_alert = ActionAlert.new(params[:action_alert])
    if @action_alert.save
      flash[:notice] = 'ActionAlert was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    @action_alert = ActionAlert.find(params[:id])
  end

  def update
    @action_alert = ActionAlert.find(params[:id])
    if @action_alert.update_attributes(params[:action_alert])
      flash[:notice] = 'ActionAlert was successfully updated.'
      redirect_to :action => 'show', :id => @action_alert
    else
      render :action => 'edit'
    end
  end

  def destroy
    ActionAlert.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
    
  protected
  
  def protect_controller
    if current_user.has_role?("Admin")
      return true
    else
      redirect_to "/publish/list"
      flash[:notice] = "You are not allowed to access this page."
    end
  end  
  
end
