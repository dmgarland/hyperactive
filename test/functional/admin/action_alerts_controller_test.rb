require File.dirname(__FILE__) + '/../../test_helper'
require 'admin/action_alerts_controller'

# Re-raise errors caught by the controller.
class Admin::ActionAlertsController; def rescue_action(e) raise e end; end

class Admin::ActionAlertsControllerTest < Test::Unit::TestCase

  fixtures :action_alerts

  def setup
    @controller = Admin::ActionAlertsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end
  


  def test_index
    get :index, {}, as_user(:marcos)
    assert_response :success
    assert_template 'list'
  end


  def test_list
    get :list, {}, as_user(:marcos)

    assert_response :success
    assert_template 'list'

    assert_not_nil assigns(:action_alerts)
  end

  def test_show
    get :show, {:id => 1}, as_user(:marcos)

    assert_response :success
    assert_template 'show'

    assert_not_nil assigns(:action_alert)
    assert assigns(:action_alert).valid?
  end

  def test_new
    get :new, {}, as_user(:marcos)

    assert_response :success
    assert_template 'new'

    assert_not_nil assigns(:action_alert)
  end

  def test_create
    num_alerts = ActionAlert.count
    post :create, {:action_alert => {:summary => "Test action alert", :on_front_page => "1"}}, as_user(:marcos)

    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_equal num_alerts + 1, ActionAlert.count   
  end

  def test_edit
    get :edit, {:id => 1}, as_user(:marcos)

    assert_response :success
    assert_template 'edit'

    assert_not_nil assigns(:action_alert)
    assert assigns(:action_alert).valid?
  end

  def test_update
    post :update, {:id => 1}, as_user(:marcos)
    assert_response :redirect
    assert_redirected_to :action => 'show', :id => 1
  end

  def test_destroy
    assert_not_nil ActionAlert.find(1)

    post :destroy, {:id => 1}, as_user(:marcos)
    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_raise(ActiveRecord::RecordNotFound) {
      ActionAlert.find(1)
    }
  end
      
  
end
