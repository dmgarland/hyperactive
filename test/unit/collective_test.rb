require File.dirname(__FILE__) + '/../test_helper'

class CollectiveTest < Test::Unit::TestCase
  fixtures :collectives

  def test_validation
    assert_invalid_value(Collective, :name, [nil, ""])
    assert_invalid_value(Collective, :summary, [nil, ""])
  end
  
  def test_upcoming_events
    @indy_london = collectives(:indy_london)
    assert_equal 3, @indy_london.events.length
    assert_equal 1, @indy_london.upcoming_events.length, "There should only be 1 upcoming event"
  end
  
end
