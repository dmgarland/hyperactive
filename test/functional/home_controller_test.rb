require File.dirname(__FILE__) + '/../test_helper'
require 'home_controller'

# Re-raise errors caught by the controller.
class HomeController; def rescue_action(e) raise e end; end

class HomeControllerTest < Test::Unit::TestCase
  fixtures :content, :tags, :taggings, :place_tags, :place_taggings

  def setup
    @controller = HomeController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # There are three event fixtures not hidden, and one promoted. However only one of the showing events
  # is in the future.
  def test_index_retrieves_content
    get :index
    assert_template 'index'
    assert_not_nil assigns(:recent_events)
    assert_equal 1, assigns(:recent_events).size
    assert_not_nil assigns(:featured_events)
    assert_equal 1, assigns(:featured_events).size
    assert assigns(:featured_videos)
    assert_match(/London Meeting 2/, @response.body)
    assert_no_match(/A Hidden Event/, @response.body)
  end
  
  def test_index_with_stick_at_top_is_stuck_at_top
    # TODO: write this test.
  end
  
  def test_index_retrieves_tag_clouds
    get :index
    assert_response :success
    assert_not_nil assigns(:cloud)
    assert_equal 2, assigns(:cloud).size
    assert_match(/bar_tag/, @response.body)
    assert_match(/foo_tag/, @response.body)  
    assert_no_match(/a_hidden_tag/, @response.body)    
    assert_not_nil assigns(:place_cloud).size
    assert_equal 2, assigns(:place_cloud).size
    assert_match(/london_tag/, @response.body)
    assert_match(/stockwell_tag/, @response.body)
    assert_no_match(/hidden_place_tag/, @response.body)
  end
  
end
