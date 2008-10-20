require File.dirname(__FILE__) + '/../test_helper'

class EventTest < Test::Unit::TestCase
  fixtures :content
  
  def test_required_fields
    assert_invalid_value(Event, :title, [nil, ""])
    assert_valid_value(Event, :title, ["a", "valid title"])
    assert_invalid_value(Event, :body, [nil, ""])
    assert_valid_value(Event, :body, ["a", "valid description"])
    assert_valid_value(Event, :date, DateTime.new)
    assert_invalid_value(Event, :published_by, [nil, ""])
    assert_valid_value(Event, :published_by, ["marcos", "ramona"])
  end
  
  def test_has_end_date
    event = Event.new
    assert !event.has_end_date?, "Expected event to not have an end date."
    event.end_date = DateTime.new
    assert event.has_end_date?, "Expected event to have an end date."
  end
  
  def test_belongs_to_event_group
    @zap_event = content(:zapatista_uprising)
    @ag_event = content(:a_birthday)
    assert !@zap_event.belongs_to_event_group?
    assert !@ag_event.belongs_to_event_group?
    event_group = EventGroup.new
    event_group.events << @zap_event
    event_group.events << @ag_event
#    event_group.save
#    assert @zap_event.belongs_to_event_group?, "Expected event to belong to event_group."
#    assert @ag_event.belongs_to_event_group?
  end
  
  # There is some custom validation for Events - the start_date needs to be after
  # the end_date if there is an end_date.
  def test_validate_end_date_after_start
    @zap_event = content(:zapatista_uprising)
    assert @zap_event.valid?
    @zap_event.date = DateTime.new
    @zap_event.end_date = @zap_event.date
    assert !@zap_event.valid?
    @zap_event.end_date = @zap_event.date << 1
    assert !@zap_event.valid?
    @zap_event.end_date = @zap_event.end_date >> 2
    assert @zap_event.valid?, "Expected event to be valid when end_date is after start date."
  end
  
  def test_date_must_be_at_least_two_hours_from_now
    @zap_event = Event.new
    @zap_event.title = "Declaration of war"
    @zap_event.body = "We are a product of 500 years of struggle: first against slavery, then during the War of Independence against Spain led by insurgents, then to avoid being absorbed by North American imperialism, then to promulgate our constitution and expel the French empire from our soil, and later the dictatorship of Porfirio Diaz denied us the just application of the Reform laws and the people rebelled and leaders like Villa and Zapata emerged, poor men just like us. We have been denied the most elemental preparation so they can use us as cannon fodder and pillage the wealth of our country. They don't care that we have nothing, absolutely nothing, not even a roof over our heads, no land, no work, no health care, no food nor education. Nor are we able to freely and democratically elect our political representatives, nor is there independence from foreigners, nor is there peace nor justice for ourselves and our children."
    @zap_event.published_by = "ezln"
    @zap_event.summary = "foo"
    @zap_event.date = DateTime.new(1994, 1, 1)
    assert !@zap_event.save
    @zap_event.date = 1.day.from_now
    assert @zap_event.save
  end
  
  # Copying an event should result in all properties being copied
  # except Tags and PlaceTags, which are different since they use 
  # :has_many_polymorphs.
  # 
  # TODO: Currently the :zapatista_uprising fixture needs some properties added
  def test_copy
    @event = content(:zapatista_uprising)
    copy = Event.copy(@event)
    assert_equal @event.title, copy.title
    assert_equal @event.date, copy.date
    assert_equal @event.body, copy.body
    assert_equal @event.place, copy.place
    assert_equal @event.moderation_status, copy.moderation_status
    assert_equal @event.created_on, copy.created_on
    assert_equal @event.updated_on, copy.updated_on
    assert_equal @event.summary, copy.summary
    assert_equal @event.source, copy.source
    assert_equal @event.published_by, copy.published_by
    assert_equal @event.user, copy.user
    assert_equal @event.event_group, copy.event_group
    assert_equal @event.photos, copy.photos
    assert_equal @event.videos, copy.videos
    assert_equal @event.file_uploads, copy.file_uploads
    assert_equal @event.links, copy.links
  end
  
end
