# An event in the calendar.
#
class Event < Post
  
  # Assocations
  #
  belongs_to :event_group  
  
  # Validations
  #
  validates_presence_of :body, :date
  
  # Macros
  #
  named_scope :upcoming, :conditions => ['date >= ?', Date.today]

    
  # Copy an event and return it as a new object.  Note that currently
  # this doesn't copy an event's tags or place tags, that needs to be done externally
  def Event.copy(event)
    new_event = Event.new
    new_event.title = event.title
    new_event.date = event.date
    new_event.body = event.body
    new_event.place = event.place
    new_event.moderation_status = event.moderation_status
    new_event.created_on = event.created_on
    new_event.updated_on = event.updated_on
    new_event.summary = event.summary
    new_event.source = event.source      
    new_event.published_by = event.published_by  
    new_event.user = event.user
    new_event.event_group = event.event_group
    new_event.photos = event.photos
    new_event.videos = event.videos
    new_event.file_uploads = event.file_uploads
    new_event.links = event.links
    new_event
  end
    
  # Returns true if the event has an end date, otherwise false.  Note that there
  # is currently no type checking, so the date is not guaranteed to be a date.  
  #
  def has_end_date?
    if end_date != nil
      return true
    else
      return false
    end
  end
  
  # Returns true if the event is part of an EventGroup.
  #
  def belongs_to_event_group?
    if event_group != nil
      true
    else
      false
    end
  end 
  
  # Returns an array of photos belonging to the first event in the event group.
  #
  def event_group_photos
    if belongs_to_event_group?
      event_group.events.first.photos
    else
      []
    end
  end
  
  # Updates all the taggings with the date of the event they're attached to.
  #
  def update_all_taggings_with_date  
    taggings.each do |tagging|
      tagging.event_date = date
      tagging.save  
    end
    place_taggings.each do |place_tagging|
      place_tagging.event_date = date
      place_tagging.save
    end    
  end


  # Hides any tags attached to this event if the event has been hidden (so we don't 
  # get any "fuckyou" tags showing up in the tag clouds on the front page).
  #
  def after_save
    if !tag_list.blank?
      taggings.each do |tagging|
        tagging.hide_tag = self.is_hidden?
        tagging.save
      end
    end
    if !place_tag_list.blank?
      place_taggings.each do |place_tagging|
        place_tagging.hide_tag = self.is_hidden?
        place_tagging.save
      end
    end
  end
  
  
  private 
  
  def validate_on_create
    validate_more_than_two_hours_from_now
  end
  
  def validate
    validate_start_date_before_end_date
  end
  
  # Validate the event to be sure that if there is an end date, it is set to
  # be after the start date.
  #
  def validate_start_date_before_end_date
    if end_date != nil
      unless end_date >  date
        errors.add(:end_date, "must be after start date")
      end
    end
  end
  
  # Validate that the event is more than 2 hours in the future
  #
  def validate_more_than_two_hours_from_now
    if date < 2.hours.from_now
      errors.add(:date, "must be at least two hours in the future")
    end
  end  
  
end