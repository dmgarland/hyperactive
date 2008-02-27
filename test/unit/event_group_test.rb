require File.dirname(__FILE__) + '/../test_helper'

class EventGroupTest < Test::Unit::TestCase
  fixtures :event_groups, :content
  
  def setup
    @event_group = EventGroup.new
    @zap_event = content(:zapatista_uprising)
    @ag_event = content(:a_birthday)
  end

  def test_first_event
    @event_group.events << @zap_event
    @event_group.events << @ag_event
    first_event = @event_group.first_event_in_group
    assert_same first_event, @zap_event
  end
  
end
