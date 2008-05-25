class HiddenController < ApplicationController
  
  layout 'home'
  before_filter :protect_controller, :except => [:list, :index, :hiding_controls, :report, :unhiding_controls, :comment_hiding_controls, :comment_unhiding_controls, :report_comment, :hide_comment]
  
  cache_sweeper :content_sweeper, :only => [:hide, :unhide]
  cache_sweeper :comment_sweeper, :only => [:hide_comment, :unhide_comment]
     
  def index
    redirect_to :action => 'list'
  end
  
  def list
    @content = Content.find(
      :all, 
      :conditions => ['moderation_status = ?', "published"], 
      :order => 'date ASC',
      :page => {:size => 50, :current => page_param})
  end
  
  def event_group_hiding_controls
    event = Event.find(params[:id])
    @id = event.event_group.id
    render :layout => false
  end
  
  def hiding_controls
    @id = params[:id]
    if current_user.has_permission?("hide")
      @content = Content.find(@id)
      render :layout => false
    else
      render :template => 'hidden/report_this_controls', :layout => false
    end
  end
   
  def hide
    if params[:hide_all_events_in_event_group]
      @event_group = Event.find(params[:id]).event_group
      hide_event_group
    else
      content = Content.find(params[:id])
      content.moderation_status = "hidden"
      content.save!
      class_name = content.class.to_s.humanize.downcase
      #set_tagging_visibility(event, false)
      ContentHideMailer.deliver_hide(content, params[:hide_reason], current_user)
      flash[:notice] = "The #{class_name} has been hidden and an email sent."
      render :update do |page|
        page.redirect_to :controller => class_name.pluralize, :action => 'show', :id => content
      end    
    end
  end

  def report
    content = Content.find(params[:id])
    class_name = content.class.to_s.humanize.downcase
    ContentHideMailer.deliver_report(content, params[:hide_reason], current_user)
    flash[:notice] = "The #{class_name} has been reported to site admins via email."
    render :update do |page|
      page.redirect_to :controller => class_name.pluralize, :action => 'show', :id => content
    end
  end   
   
  def unhiding_controls
    @id = params[:id]
    if current_user.has_permission?("hide")
      render :layout => false
    else
      render :template => 'hidden/unreport_this_controls', :layout => false
    end      
  end
  
  def unhide
    content = Content.find(params[:id])
    content.moderation_status = "published"
    content.save!
    class_name = content.class.to_s.humanize.downcase    
    #set_tagging_visibility(event, true)
    ContentHideMailer.deliver_unhide(content, params[:unhide_reason], current_user)
    flash[:notice] = "The #{class_name} has been unhidden and an email sent."
    render :update do |page|
      page.redirect_to :controller => class_name.pluralize, :action => 'show', :id => content
    end
  end
    
  def comment_hiding_controls
    @id = params[:id]
    @comment = Comment.find(@id)
    if can_hide?(@comment)      
      render :layout => false
    else
      render :template => 'hidden/report_comment_controls', :layout => false
    end
  end  

  def comment_unhiding_controls
    @id = params[:id]
    if current_user.has_permission?("hide")
      render :layout => false
    else
      render :text => "You are not allowed to unhide things."
    end      
  end  
  
  def report_comment
    comment = Comment.find(params[:id])
    class_name = comment.content.class.to_s.humanize.downcase
    ContentHideMailer.deliver_report_comment(comment, params[:hide_reason], current_user)
    flash[:notice] = "The comment has been reported to site admins via email."
    render :update do |page|
      page.redirect_to :controller => class_name.pluralize, :action => 'show', :id => comment.content
    end
  end
  
  def hide_comment
    comment = Comment.find(params[:id])
    class_name = comment.content.class.to_s.humanize.downcase
    if can_hide?(comment)
      comment.moderation_status = "hidden"
      comment.save!
      ContentHideMailer.deliver_hide_comment(comment, params[:hide_reason], current_user)
      flash[:notice] = "The comment has been hidden and reported via email."
      render :update do |page|
        page.redirect_to :controller => class_name.pluralize, :action => 'show', :id => comment.content
      end
    else
      security_error
    end
  end
  
  def unhide_comment
    comment = Comment.find(params[:id])
    comment.moderation_status = "published"
    comment.save!
    ContentHideMailer.deliver_unhide_comment(comment, params[:unhide_reason], current_user)
    flash[:notice] = "The comment has been unhidden."
    render :update do |page|
      page.redirect_to latest_comments_url
    end
  end
  
  private
  
  def hide_event_group
    @event_group.events.each do |event|
      event.moderation_status = "hidden"
      event.save
    end
    event = @event_group.events.first
    ContentHideMailer.deliver_hide(event, params[:hide_reason], current_user)
    flash[:notice] = "The events have been hidden and an email sent."
    render :update do |page|
      page.redirect_to event_url(event)
    end  
  end  
  
  # TODO: this is gross, but it's the quickest way i can think of 
  # to ensure that tags for hidden events don't show up in tag clouds
#  def set_tagging_visibility(event, visiblity)

#  end  

  # Checks permissions and ownership to see if a given user can hide a comment.
  #
  def can_hide?(comment)
    return true if current_user.has_permission?("hide")  
    return true if current_user.has_permission?("hide_own_content")  && comment.content.user == current_user
    return false
  end
  
end
