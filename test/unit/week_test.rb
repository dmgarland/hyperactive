require File.dirname(__FILE__) + '/../test_helper'
require 'calendar_dates/week'

class WeekTest < Test::Unit::TestCase

  def test_constructor
    @week = Week.new(Date.new(2007,05,01))
    assert_instance_of(Week, @week)
  end
  
  def test_first_day_in_week
    @week = Week.new(Date.new(2007,05,01))
    first = @week.first_day_in_week
    assert_instance_of(Date, first, "First day in week expected to be a DateTime object")
    assert_equal first, Date.new(2007, 04, 30), "Monday 30 April is the first day in the week starting on 1 May 2007"
  end
  
end
