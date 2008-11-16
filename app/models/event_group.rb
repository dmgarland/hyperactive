# A series of repeating events.
#
class EventGroup < ActiveRecord::Base

  has_many :events
  
  # TODO: there should probably be a validation to make sure that the same event cannot be
  # added twice to the same EventGroup, but I am not currently sure how to express this.
    
  def first_event_in_group
    @events.first
  end

end
