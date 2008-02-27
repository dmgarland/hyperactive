require File.dirname(__FILE__) + '/../test_helper'
require 'event_feed_controller'

# Re-raise errors caught by the controller.
class EventFeedController; def rescue_action(e) raise e end; end

class EventFeedControllerTest < Test::Unit::TestCase
  def setup
    @controller = EventFeedController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
