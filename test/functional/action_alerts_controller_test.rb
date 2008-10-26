require File.dirname(__FILE__) + '/../test_helper'
require 'action_alerts_controller'

# Re-raise errors caught by the controller.
class ActionAlertsController; def rescue_action(e) raise e end; end

class ActionAlertsControllerTest < Test::Unit::TestCase
  
  fixtures :action_alerts
  
  def setup
    @controller = ActionAlertsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end


  def test_show
    get :show, :id => 1
    assert_response :success
    assert_template 'show'
    assert_not_nil assigns(:action_alert)
  end
  
end
