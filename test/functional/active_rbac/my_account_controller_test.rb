require File.dirname(__FILE__) + '/../../test_helper'
require 'active_rbac/my_account_controller'

# Re-raise errors caught by the controller.
#class ActiveRbac::MyAccountController; def rescue_action(e) raise e end; end

class ActiveRbac::MyAccountControllerTest < ActionController::TestCase
  fixtures :roles, :users, :roles_users, :static_permissions, :roles_static_permissions

  tests ActiveRbac::MyAccountController

  def setup
    @controller = ActiveRbac::MyAccountController.new
    request    = ActionController::TestRequest.new
    response   = ActionController::TestResponse.new
    
    @valid_data = {
      :current_password => 'password',
      :password => 'new password',
      :password_confirmation => 'new password'
    }
  end
  
  def test_index
    get :index, {}, as_user(:registered_user)
    assert_response :success
  end
  
  def test_index_security
    get :index, {}
    assert_redirected_to login_path
  end
  
  # sets the user to a valid value
  def set_user
    user = User.find(users(:registered_user))
    user.state = User.states['retrieved_password']
    user.save!
    
    @request.session[:rbac_user_id] = users(:registered_user).id
  end


  def test_change_password_redirects_to_login_path_when_not_logged_in
    # check GET as well as POST
    [ :get, :post ].each do |sym|
      self.send(sym, :change_password)
    
      assert_response :redirect
      assert_redirected_to login_path
      assert flash[:error]
    end
  end

  def test_change_password_renders_form_on_GET_when_logged_in
    set_user
    get :change_password
    
    assert_response :success
    assert_template 'change_password'
  end

  def test_change_password_allows_password_change_with_valid_data_on_POST_when_logged_in
    set_user
    post :change_password, @valid_data

    assert_response :success
    assert_template 'change_password'
    assert flash[:notice]
    
    user = User.find(users(:registered_user))
    
    assert ! user.password_equals?('password')
    assert user.password_equals?('new password')
    
    # make sure the password is confirmed now
    assert_equal User.states['confirmed'], user.state 
  end
  
  # Note that we only test for matching since validation is sufficiently tested
  # in other places.
  def test_change_password_blocks_with_invalid_data_on_POST_when_logged_in
    set_user

    patches = [ 
        [ :current_password => nil], [ :current_password => 'not the password' ],
        [ :password => nil], [ :password => 'not the password' ],
        [ :password_confirmation => nil], [ :password_confirmation => 'not the password' ]
      ]
    
    patches.each do |patch|
      key, value = patch
      
      invalid_data = @valid_data.dup
      
      post :change_password, invalid_data
      
      assert_response :success
      assert_template 'change_password'

      user = User.find(users(:registered_user))
      assert user.password_equals?(@valid_data[:password])
    end
  end
end
