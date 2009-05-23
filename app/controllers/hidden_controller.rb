class HiddenController < ApplicationController
  
  layout 'home'
  before_filter :can_use_hide_content?, :only => [:hide, :event_group_hiding_controls, :unhide]
  before_filter :can_use_hide_comment?, :only => 
        [:hide_comment, :unhide_comment]
  after_filter :notify_moderators, :only => [:hide, :unhide, :report, :promote]
      
  cache_sweeper :content_sweeper, :only => [:hide, :unhide]
  cache_sweeper :comment_sweeper, :only => [:hide_comment, :unhide_comment]
     
  def index
    redirect_to :action => 'list'
  end
  
  def list
    @content = Content.paginate(
      :conditions => ['moderation_status = ?', "hidden"], 
      :order => 'created_on DESC',
      :page => page_param)
  end
  
  def event_group_hiding_controls
    event = Event.find(params[:id])
    @id = event.event_group.id
    render :layout => false
  end
 
  def hide
    if params[:hide_all_events_in_event_group]
      @event_group = Event.find(params[:id]).event_group
      @content = @event_group.events.first
      hide_event_group
    else
      @content = Content.find(params[:id])
      @content.moderation_status = "hidden"
      @content.save!
      class_name = @content.class.to_s.humanize.downcase
      ContentHideMailer.deliver_hide(@content, params[:hide_reason], current_user)
      flash[:notice] = "The #{class_name} has been hidden and an email sent."
      render :update do |page|
        page.redirect_to  :controller => class_name.pluralize, 
                          :action => 'show', :id => @content
      end    
    end
  end

  def report
    @content = Content.find(params[:id])
    class_name = @content.class.to_s.humanize.downcase
    ContentHideMailer.deliver_report(@content, params[:hide_reason], current_user)
    flash[:notice] = "The #{class_name} has been reported to site admins via email."
    render :update do |page|
      page.redirect_to  :controller => class_name.pluralize, 
                        :action => 'show', :id => @content
    end
  end   
  
  def promote
   if params[:promote_all_events_in_event_group]
      @event_group = Event.find(params[:id]).event_group
      promote_event_group
    else
      @content = Content.find(params[:id])
      @content.moderation_status = "promoted"
      @content.save!
      class_name = @content.class.to_s.humanize.downcase
      ContentHideMailer.deliver_promote(@content, params[:promote_reason], current_user)
      flash[:notice] = "The #{class_name} has been promoted and an email sent."
      render :update do |page|
        page.redirect_to  :controller => class_name.pluralize, 
                          :action => 'show', :id => @content
      end    
    end    
  end
   
  def unhiding_controls
    @id = params[:id]
    if current_user.can_unhide_content?(Content.find(params[:id]))
      render :layout => false
    else
      render :template => 'hidden/unreport_this_controls', :layout => false
    end      
  end
  
  def unhide
    @content = Content.find(params[:id])
    @content.moderation_status = "published"
    @content.save!
    class_name = @content.class.to_s.humanize.downcase    
    ContentHideMailer.deliver_unhide(@content, params[:unhide_reason], current_user)
    flash[:notice] = "The #{class_name} has been unhidden and an email sent."
    render :update do |page|
      page.redirect_to :controller => class_name.pluralize, :action => 'show', :id => @content
    end
  end
    
  def comment_hiding_controls
    @id = params[:id]
    if current_user.can_hide_comment?(Comment.find(params[:id])) 
      render :layout => false
    else
      render :template => 'hidden/report_comment_controls', :layout => false
    end
  end  

  def comment_unhiding_controls
    @id = params[:id]
    if current_user.can_hide_comment?(Comment.find(params[:id]))
      render :layout => false
    else
      render :text => "You are not allowed to unhide things."
    end      
  end  
  
  def report_comment
    @comment = Comment.find(params[:id])
    class_name = @comment.content.class.to_s.humanize.downcase
    ContentHideMailer.deliver_report_comment(@comment, params[:hide_reason], current_user)
    flash[:notice] = "The comment has been reported to site admins via email."
    render :update do |page|
      page.redirect_to :controller => class_name.pluralize, :action => 'show', :id => @comment.content
    end
  end
  
  def hide_comment
    @comment = Comment.find(params[:id])
    class_name = @comment.content.class.to_s.humanize.downcase
    @comment.moderation_status = "hidden"
    @comment.save!
    ContentHideMailer.deliver_hide_comment(@comment, params[:hide_reason], current_user)
    flash[:notice] = "The comment has been hidden and reported via email."
    render :update do |page|
      page.redirect_to :controller => class_name.pluralize, :action => 'show', :id => @comment.content
    end
  end
  
  def unhide_comment
    @comment = Comment.find(params[:id])
    @comment.moderation_status = "published"
    @comment.save!
    ContentHideMailer.deliver_unhide_comment(@comment, params[:unhide_reason], current_user)
    flash[:notice] = "The comment has been unhidden."
    render :update do |page|
      page.redirect_to latest_comments_path
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
      page.redirect_to event_path(event)
    end  
  end  
  
  def promote_event_group
    @event_group.events.each do |event|
      event.moderation_status = "promoted"
      event.save
    end
    event = @event_group.events.first
    ContentHideMailer.deliver_promote(event, params[:promote_reason], current_user)
    flash[:notice] = "The events have been promoted and an email sent."
    render :update do |page|
      page.redirect_to event_path(event)
    end  
  end    
  
  # TODO: this is gross, but it's the quickest way i can think of 
  # to ensure that tags for hidden events don't show up in tag clouds
#  def set_tagging_visibility(event, visiblity)

#  end  

  def can_use_hide_comment?
    if current_user.can_hide_comment?(Comment.find(params[:id]))
      true
    else
      security_error
    end
  end
  
  def can_use_hide_content?
    if current_user.can_hide_content?(Content.find(params[:id]))
      true
    else
      security_error
    end
  end
  
  def notify_moderators
    tell_irc_channel
    append_to_admin_note
  end
  
  # Tells the bot's irc channel that content has been created or updated
  #
  def tell_irc_channel
    notify_irc_channel ("#{Hyperactive.site_url}#{content_path_for(@content)} :: '#{@content.title}' is now #{@content.moderation_status}.")
    notify_irc_channel(@content.summary.gsub(/<\/?[^>]*>/,""))
  end  
  
  def append_to_admin_note
    @content.append_admin_note("User '#{current_user.login}' did: #{@current_action} at #{Time.now}.")
    @content.save!
  end
  
end
