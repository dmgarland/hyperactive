require File.dirname(__FILE__) + '/../../test_helper'
require 'admin/main_controller'

# Re-raise errors caught by the controller.
class Admin::MainController; def rescue_action(e) raise e end; end

class Admin::MainControllerTest < Test::Unit::TestCase
  fixtures :comments

  def setup
    @controller = Admin::MainController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  def test_index
    get :index, {}, as_user(:marcos)
    assert_response :success
    assert_template 'index'
  end
  
  def test_latest_comments
    get :latest_comments, {}, as_user(:marcos)
    assert_response :success
    assert_template 'latest_comments'
    assert assigns(:comments)
  end  
  
  def test_edit_comment
    get :edit_comment, {:id => comments(:one).id}, as_user(:marcos)
    assert_response :success
    assert assigns(:comment)
  end

end
