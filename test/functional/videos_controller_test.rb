require File.dirname(__FILE__) + '/../test_helper'
require 'videos_controller'

# Re-raise errors caught by the controller.
class VideosController; def rescue_action(e) raise e end; end

class VideosControllerTest < Test::Unit::TestCase
  
  fixtures :content
  
  def setup
    @controller = VideosController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    @content_id = content(:first_video).id
  end

  def test_index
    get :index
    assert_response :success
    assert assigns(:content)
  end
  
  def test_new
    get :new
    assert_response :success
    assert assigns(:content)
  end
  
  def test_show
    get :show, :id => @content_id
    assert_response :success
    assert assigns(:content)
  end
  
end
