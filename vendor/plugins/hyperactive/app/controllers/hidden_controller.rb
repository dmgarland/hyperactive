class HiddenController < ApplicationController
  
  layout 'home'
  
  def index
    redirect_to :action => 'list'
  end
  
  def list
    @events = Event.find(
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
    EventHiddenMailer.deliver_hide(event, params[:hide_reason], current_user)
    flash[:notice] = "The events have been hidden and an email sent."
    render :update do |page|
      page.redirect_to event_url(event)
    end  
  end
  
  def hiding_controls
    @id = params[:id]
    render :layout => false
  end
  
  def hide
    event = Event.find(params[:id])
    event.hidden = 1
    event.save
    #set_tagging_visibility(event, false)
    EventHiddenMailer.deliver_hide(event, params[:hide_reason], current_user)
    flash[:notice] = "The event has been hidden and an email sent."
    render :update do |page|
      page.redirect_to event_url(event)
    end
  end
   
  def unhiding_controls
    @id = params[:id]
    render :layout => false
  end
  
  def unhide
    event = Event.find(params[:id])
    event.hidden = 0
    event.save
    #set_tagging_visibility(event, true)
    EventHiddenMailer.deliver_unhide(event, params[:unhide_reason], current_user)
    flash[:notice] = "The event has been unhidden and an email sent."
    render :update do |page|
      page.redirect_to event_url(event)
    end
  end
  
  protected
  
  before_filter :protect_controller, :except => [:list, :index]
  
  private
  
  # TODO: this is gross, but it's the quickest way i can think of 
  # to ensure that tags for hidden events don't show up in tag clouds
#  def set_tagging_visibility(event, visiblity)

#  end  
  
end
