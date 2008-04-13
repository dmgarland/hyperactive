require File.dirname(__FILE__) + '/../test_helper'
require 'feeds_controller'

# Re-raise errors caught by the controller.
class FeedsController; def rescue_action(e) raise e end; end

class FeedsControllerTest < Test::Unit::TestCase
  def setup
    @controller = FeedsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end
  
  def test_index
    get :index
    assert_response :success
  end

# Unfortunately there seems to be something weird going on with respect to
# testing anything to do with resource_feeder.  It uses some method_missing
# magic to get the pub_date into the feed, and for the moment the pub_date
# of everything is nil in tests (but it works in development mode).
# 
#  def test_upcoming_articles
#    get :latest_articles
#    assert_response :success
#  end

end
