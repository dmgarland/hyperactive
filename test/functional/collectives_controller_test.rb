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
    assert assigns(:recently_active_collectives)
    assert assigns(:new_collectives)
  end

  def test_should_get_new
    get :new,{}, as_user(:registered_user)
    assert_match /New group/, @response.body
    assert_response :success
  end
  
  def test_should_not_show_form_for_anonymous_user
    get :new
    assert_match /Please create an account/, @response.body
    assert_no_match /Create/, @response.body
  end  
  
  def test_should_create_collective
    old_count = Collective.count
    post :create, {:collective => {:name => "ezln", :summary => "foo" }}, as_user(:registered_user)
    assert_equal old_count+1, Collective.count
    assert_redirected_to group_path(assigns(:collective))
    assert assigns(:collective).users.include?(users(:registered_user))
  end
  
  def test_should_not_create_collective_for_anonymous_user
    old_count = Collective.count
    post :create, {:collective => {:name => "ezln", :summary => "foo" }}
    assert_equal old_count, Collective.count
    assert_security_error
  end  

  def test_should_show_collective
    get :show, :id => 1
    assert_response :success
    assert_template 'show'
  end

  def test_should_get_edit
    get :edit, {:id => 1}, as_user(:registered_user)
    assert_response :success
  end
  
  def test_anonymous_user_cannot_edit
    get :edit, :id => 1
    assert_security_error
  end  
  
  def test_should_update_collective
    put :update, {:id => 1, :collective => { }}, as_user(:registered_user)
    assert_redirected_to account_path
  end
  
  def test_update_security
    collective = collectives(:indy_london)
    put :update, :id => 1, :collective => {:name => "foo foo foo" }
    assert_equal collective.name, Collective.find(1).name
    assert_security_error
  end  
  
  def test_should_destroy_collective
    old_count = Collective.count
    delete :destroy, {:id => 1}, as_user(:marcos)
    assert_equal old_count-1, Collective.count
    
    assert_redirected_to groups_path
  end
  
  def test_destroy_security
    old_count = Collective.count
    delete :destroy, {:id => 1}
    assert_equal old_count, Collective.count
    
    assert_security_error
  end  
  
  def test_admin_user_can_edit
    get :edit, {:id => 1}, as_user(:marcos)
    assert_response :success
    assert_template 'edit'
  end
  
  def test_admin_user_can_update
    put :update, {:id => 1, :collective => {:moderation_status => "featured" }}, as_user(:marcos)
    assert_equal assigns(:collective).moderation_status, "featured"
    assert_redirected_to account_path
  end

  def test_non_admin_collective_member_cannot_set_moderation_status_on_create
    post :create, {:collective => {:name => "makhnovischina", :summary => "foo", :moderation_status => "featured" }}, as_user(:registered_user)
    assert_equal assigns(:collective).moderation_status, "published"
    assert_redirected_to group_path(assigns(:collective))
  end
  
  def test_non_admin_collective_member_cannot_set_moderation_status_on_update
    original_status = collectives(:indy_london).moderation_status
    put :update, {:id => 1, :collective => {:moderation_status => "featured" }}, as_user(:registered_user)
    assert_equal assigns(:collective).moderation_status, original_status
    assert_redirected_to account_path
  end  
  
end
