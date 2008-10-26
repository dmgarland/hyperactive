class Admin::MainController < ApplicationController

  layout "admin"

  include SslRequirement
  ssl_required :all

  before_filter :protect_controller
 
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
    
end
