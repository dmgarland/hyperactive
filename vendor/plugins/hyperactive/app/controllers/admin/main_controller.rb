class Admin::MainController < ApplicationController

  layout "admin"

  def index
  end

  def latest_comments
    @comments = Comment.find(:all, :limit => 20, :order => 'created_on DESC', :page => {:size => objects_per_page, :current => page_param})
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
