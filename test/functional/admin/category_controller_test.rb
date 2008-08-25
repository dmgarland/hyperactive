require File.dirname(__FILE__) + '/../../test_helper'
require 'admin/category_controller'
require 'vendor/plugins/active_rbac/app/controllers/active_rbac/login_controller.rb'

# Re-raise errors caught by the controller.
class Admin::CategoryController; def rescue_action(e) raise e end; end

class Admin::CategoryControllerTest < Test::Unit::TestCase

  fixtures :categories

  def setup
    @controller = Admin::CategoryController.new
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

    assert_not_nil assigns(:categories)
  end

  def test_show
    get :show, {:id => 1}, as_user(:marcos)

    assert_response :success
    assert_template 'show'

    assert_not_nil assigns(:category)
    assert assigns(:category).valid?
  end

  def test_new
    get :new, {}, as_user(:marcos)

    assert_response :success
    assert_template 'new'

    assert_not_nil assigns(:category)
  end

  def test_create
    num_categories = Category.count
    post :create, {:category => {:name => "Test category", :description => "Events having to do with anti-GM food.", :active => "1"}}, as_user(:marcos)

    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_equal num_categories + 1, Category.count   
  end

  def test_edit
    get :edit, {:id => 1}, as_user(:marcos)

    assert_response :success
    assert_template 'edit'

    assert_not_nil assigns(:category)
    assert assigns(:category).valid?
  end

  def test_update
    post :update, {:id => 1}, as_user(:marcos)
    assert_response :redirect
    assert_redirected_to :action => 'show', :id => 1
  end

  def test_destroy
    assert_not_nil Category.find(1)

    post :destroy, {:id => 1}, as_user(:marcos)
    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_raise(ActiveRecord::RecordNotFound) {
      Category.find(1)
    }
  end
    
end
