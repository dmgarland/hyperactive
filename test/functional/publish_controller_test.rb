require File.dirname(__FILE__) + '/../test_helper'
require 'publish_controller'

# Re-raise errors caught by the controller.
class PublishController; def rescue_action(e) raise e end; end

class PublishControllerTest < Test::Unit::TestCase
  def setup
    @controller = PublishController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  def test_index
    get :index
    assert_response :success
  end
  
end
