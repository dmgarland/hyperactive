class Admin::MainController < ApplicationController

  include SslRequirement
  ssl_required :all

  layout "admin"
  
  cache_sweeper :comment_sweeper, :only => [:update_comment]

  def index
  end

  def latest_comments
    @comments = Comment.paginate(:order => 'created_on DESC', :page => page_param)
  end
  
  def edit_comment
    @comment = Comment.find(params[:id])
  end
  
  def update_comment
    @comment = Comment.find(params[:id])
    @comment.update_attributes(params[:comment])
    if @comment.save
      redirect_to :action => 'latest_comments'
    else
      render :action => 'edit_comment'
    end
  end
  
  before_filter :protect_controller
  
  def protect_controller
    if current_user.has_role?("Admin")
      return true
    else
      redirect_to "/publish/list"
      flash[:notice] = "You are not allowed to access this page."
    end
  end  
  
end
