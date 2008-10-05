require File.dirname(__FILE__) + '/../test_helper'
require 'active_rbac/login_controller'

# Re-raise errors caught by the controller.
class ActiveRbac::LoginController; def rescue_action(e) raise e end; end

class ActiveRbac::LoginControllerTest < Test::Unit::TestCase
  fixtures :roles, :users, :groups, :roles_users, :user_registrations, :groups_users, :groups_roles, :static_permissions, :roles_static_permissions

  def setup
    @controller = ActiveRbac::LoginController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    
    @valid_data = {
      :login => users(:registered_user).login,
      :password => 'password'
    }
    @invalid_login_data = {
      :login => users(:registered_user).login + 'invalid',
      :password => 'password'
    }
    @invalid_password_data = {
      :login => users(:registered_user).login,
      :password => 'password' + 'invalid'
    }
  end

  def test_should_reset_session_on_login
    @request.session[:some_key] = 'some value'
    
    post :login, :login => @valid_data[:login], :password => @valid_data[:password]
    
    assert_response :success
    
    assert_nil session[:some_key]
  end
  
  def test_should_reset_session_on_logout
    @request.session[:rbac_user_id] = users(:registered_user).id
    @request.session[:some_key] = 'some value'
    
    post :logout, :yes => 'Yes'
    
    assert_response :success
    
    assert_nil session[:some_key]
  end
  
  def test_should_redirect_to_login_on_index
    get :index
    
    assert_redirected_to :action => 'login'
  end

  def test_should_display_login_form_on_login
    get :login

    assert_response :success
    assert_template 'login'
  end

  def test_should_render_success_template_on_valid_login_without_in_redirect
    valid_states_for_login = [ User.states['confirmed'], User.states['retrieved_password'] ]
    
    for state in valid_states_for_login
      @request.session[:rbac_user_id] = nil
      
      user = User.find_by_login(@valid_data[:login])
      user.state = state
      user.save!
      
      post :login, :login => @valid_data[:login], :password => @valid_data[:password]

      assert_response :success
      assert_template 'login_success'
      assert_equal nil, flash[:success]

      assert_equal users(:registered_user).id, session[:rbac_user_id]
      
    end
  end

  def test_should_redirect_on_valid_login_with_return_to_in_param
    post :login, :login => @valid_data[:login], :password => @valid_data[:password],
      :return_to => '/'
    
    assert_response :redirect
    assert_redirected_to '/'
    # This is commented out because of a bug in Rails (http://dev.rubyonrails.org/ticket/4240).
    # We will uncomment this when the bug has been fixed.
    ##assert_equal 'You have logged in successfully.', session[:flash]
    
    assert_equal users(:registered_user).id, session[:rbac_user_id]
  end
  
  def test_should_redirect_on_valid_login_with_return_to_in_session
    @request.session[:return_to] = '/'
    post :login, :login => @valid_data[:login], :password => @valid_data[:password]
    
    assert_response :redirect
    assert_redirected_to '/'
    # This is commented out because of a bug in Rails (http://dev.rubyonrails.org/ticket/4240).
    # We will uncomment this when the bug has been fixed.
    ##assert_equal 'You have logged in successfully.', session[:flash]
    
    assert_equal users(:registered_user).id, session[:rbac_user_id]
  end
  
  def test_should_prefer_session_redirect_over_param_redirect
    @request.session[:return_to] = '/'

    post :login, :login => @valid_data[:login], :password => @valid_data[:password],
      :return_to => '/foo'
    
    assert_response :redirect
    assert_redirected_to '/'
    # This is commented out because of a bug in Rails (http://dev.rubyonrails.org/ticket/4240).
    # We will uncomment this when the bug has been fixed.
    ##assert_equal 'You have logged in successfully.', session[:flash]
    assert_equal nil, session[:return_to]
    
    assert_equal users(:registered_user).id, session[:rbac_user_id]
  end
  
  def test_should_not_allow_post_to_login_with_invalid_user_login
    post :login, :login => @invalid_login_data[:login], :password => @invalid_login_data[:password]

    assert_response :success
    assert_template 'login'

    assert_nil session[:rbac_user_id]
  end
  
  def test_should_not_allow_post_to_login_with_invalid_password
    post :login, :login => @invalid_password_data[:login], :password => @invalid_password_data[:password]

    assert_response :success
    assert_template 'login'

    assert_nil session[:rbac_user_id]
  end
  
  def test_should_display_confirmation_form_on_logout
    # first do a valid login
    test_should_render_success_template_on_valid_login_without_in_redirect

    # then request logout form
    get :logout
    
    assert_response :success
    assert_template 'logout'

    assert_equal users(:registered_user).id, session[:rbac_user_id]
  end

  def test_should_perform_logout_when_logged_in_by_post_with_yes
    # first do a valid login
    test_should_render_success_template_on_valid_login_without_in_redirect

    # then try to logout
    post :logout, :yes => 'Yes'

    assert_response :success
    assert_template 'logout_success'

    assert_nil session[:rbac_user_id]
  end

  def test_should_not_perform_logout_when_logged_in_by_post_with_no
    # first do a valid login
    test_should_render_success_template_on_valid_login_without_in_redirect

    # then try to logout
    post :logout, :no => 'No'

    assert_response :redirect
    assert_redirected_to '/'

    assert_equal users(:registered_user).id, session[:rbac_user_id]
  end

  def test_should_redirect_on_logout_when_not_logged_in
    get :logout

    assert_response :redirect
    assert_redirected_to '/'
  end

  def test_should_redirect_on_perform_logout_when_not_logged_in
    post :logout, :yes => 'Yes'

    assert_response :redirect
    assert_redirected_to '/'
  end
end