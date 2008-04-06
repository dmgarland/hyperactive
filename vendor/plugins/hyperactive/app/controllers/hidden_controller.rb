class HiddenController < ApplicationController
  
  layout 'home'
  before_filter :protect_controller, :except => [:list, :index, :hiding_controls, :report, :unhiding_controls]
  
  cache_sweeper :content_sweeper, :only => [:hide, :unhide]
  
  
  def index
    redirect_to :action => 'list'
  end
  
  def list
    @content = Content.find(
      :all, 
      :conditions => ['hidden = ? and published =?', true, true], 
      :order => 'date ASC',
      :page => {:size => 50, :current => page_param})
  end
  
  def event_group_hiding_controls
    event = Event.find(params[:id])
    @id = event.event_group.id
    render :layout => false
  end
  
  def hide_event_group
    event_group = EventGroup.find(params[:id])
    event_group.events.each do |event|
      event.hidden = 1
      event.save
    end
    event = event_group.events.first
    ContentHideMailer.deliver_hide(event, params[:hide_reason], current_user)
    flash[:notice] = "The events have been hidden and an email sent."
    render :update do |page|
      page.redirect_to event_url(event)
    end  
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
    content = Content.find(params[:id])
    content.hidden = true
    content.save!
    class_name = content.class.to_s.humanize.downcase
    #set_tagging_visibility(event, false)
    ContentHideMailer.deliver_hide(content, params[:hide_reason], current_user)
    flash[:notice] = "The #{class_name} has been hidden and an email sent."
    render :update do |page|
      page.redirect_to :controller => class_name.pluralize, :action => 'show', :id => content
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
    content.hidden = false
    content.save!
    class_name = content.class.to_s.humanize.downcase    
    #set_tagging_visibility(event, true)
    ContentHideMailer.deliver_unhide(content, params[:unhide_reason], current_user)
    flash[:notice] = "The #{class_name} has been unhidden and an email sent."
    render :update do |page|
      page.redirect_to :controller => class_name.pluralize, :action => 'show', :id => content
    end
  end
    
  private
  
  # TODO: this is gross, but it's the quickest way i can think of 
  # to ensure that tags for hidden events don't show up in tag clouds
#  def set_tagging_visibility(event, visiblity)

#  end  
  
end
