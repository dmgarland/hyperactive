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


  def test_action_alerts
    get :action_alerts
    assert_response :success
  end
  
  def test_latest_articles
    get :latest_articles
    assert_response :success
  end
  
  def test_latest_videos
    get :latest_videos
    assert_response :success
  end
  
  def test_upcoming_events
    get :upcoming_events
    assert_response :success    
  end
  
  def test_upcoming_events_by_tag
    get :upcoming_events_by_tag, :scope => "foo"
    assert_response :success      
  end

  def test_upcoming_events_by_place
    get :upcoming_events_by_place, :scope => "brixton"
    assert_response :success   
  end

end
