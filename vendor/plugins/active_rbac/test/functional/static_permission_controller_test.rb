require File.dirname(__FILE__) + '/../test_helper'


class ActiveRbac::StaticPermissionControllerTest < ActionController::TestCase
  fixtures :roles, :users, :groups, :roles_users, :user_registrations, :groups_users, :groups_roles, :static_permissions, :roles_static_permissions

  tests ActiveRbac::StaticPermissionController

  def test_should_redirect_to_get_on_list_GET
    get :index
    assert_response :redirect
    assert_redirected_to :action => 'list'
  end

  def test_should_display_list_on_list_GET
    get :list

    assert_response :success
    assert_template 'list'

    assert_not_nil assigns(:permissions)
  end

  def test_should_display_permission_on_show_GET
    get :show, :id => 1

    assert_response :success
    assert_template 'show'

    assert_not_nil assigns(:permission)
    assert assigns(:permission).valid?
  end

  def test_should_display_create_form_on_create_GET
    get :create

    assert_response :success
    assert_template 'create'

    assert_not_nil assigns(:permission)
  end

  def test_should_create_new_permission_on_create_POST_with_valid_data
    num_permissions = StaticPermission.count

    post :create, :permission => { 'title' => 'Nice Permission' }

    assert_response :redirect
    assert_redirected_to :action => 'show', :id => assigns(:permission)
    assert_equal num_permissions + 1, StaticPermission.count
  end

  def test_should_display_update_form_on_update_GET
    get :update, :id => 1

    assert_response :success
    assert_template 'update'

    assert_not_nil assigns(:permission)
    assert assigns(:permission).valid?
  end

  def test_update_permission_on_update_POST
    post :update, :id => 1
    assert_response :redirect
    assert_redirected_to :action => 'show', :id => 1
  end

  def test_should_display_confirmation_form_on_delete_GET
    get :delete, :id => 1
    
    assert_response :success
    assert_template 'delete'
    
    assert assigns(:permission)
  end

  def test_should_delete_permission_on_delete_POST_with_yes
    assert_not_nil StaticPermission.find(1)

    post :delete, :id => 1, :yes => 'Yes'
    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_raise(ActiveRecord::RecordNotFound) {
      StaticPermission.find(1)
    }
  end
  
  def test_should_not_delete_permission_on_delete_POST_with_no
    assert_not_nil StaticPermission.find(1)

    post :delete, :id => 1, :no => 'No'
    assert_response :redirect
    assert_redirected_to :action => 'show', :id => "1"
  end
end
