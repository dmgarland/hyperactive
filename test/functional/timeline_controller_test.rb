require File.dirname(__FILE__) + '/../test_helper'
require 'timeline_controller'

# Re-raise errors caught by the controller.
class TimelineController; def rescue_action(e) raise e end; end

class TimelineControllerTest < Test::Unit::TestCase
  def setup
    @controller = TimelineController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Shouldn't bomb out when generating JSON data for the timeline
  def test_show_calendar
    get :show_calendar
    assert_response :success
  end
  
  def test_timeline
    get :timeline
    assert_response :success
  end
  
end
