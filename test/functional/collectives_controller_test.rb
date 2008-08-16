require File.dirname(__FILE__) + '/../test_helper'
require 'collectives_controller'

# Re-raise errors caught by the controller.
class CollectivesController; def rescue_action(e) raise e end; end

class CollectivesControllerTest < Test::Unit::TestCase
  fixtures :collectives

  def setup
    @controller = CollectivesController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  def test_should_get_index
    get :index
    assert_response :success
    assert assigns(:collectives)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end
  
  def test_should_create_collective
    old_count = Collective.count
    post :create, :collective => {:name => "ezln", :summary => "foo" }
    assert_equal old_count+1, Collective.count
    
    assert_redirected_to collective_path(assigns(:collective))
  end

  def test_should_show_collective
    get :show, :id => 1
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => 1
    assert_response :success
  end
  
  def test_should_update_collective
    put :update, :id => 1, :collective => { }
    assert_redirected_to collective_path(assigns(:collective))
  end
  
  def test_should_destroy_collective
    old_count = Collective.count
    delete :destroy, :id => 1
    assert_equal old_count-1, Collective.count
    
    assert_redirected_to collectives_path
  end
end
