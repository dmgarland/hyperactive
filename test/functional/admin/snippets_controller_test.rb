require File.dirname(__FILE__) + '/../../test_helper'
require 'admin/snippets_controller'

# Re-raise errors caught by the controller.
class Admin::SnippetsController; def rescue_action(e) raise e end; end

class Admin::SnippetsControllerTest < Test::Unit::TestCase
  fixtures :snippets

  def setup
    @controller = Admin::SnippetsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  def test_should_get_index
    get :index
    assert_response :success
    assert assigns(:snippets)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end
  
  def test_should_create_snippet
    old_count = Snippet.count
    post :create, :snippet => {:title => "foo" }
    assert_equal old_count+1, Snippet.count
    
    assert_redirected_to admin_snippet_path(assigns(:snippet))
  end

  def test_should_show_snippet
    get :show, :id => 1
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => 1
    assert_response :success
  end
  
  def test_should_update_snippet
    put :update, :id => 1, :snippet => { }
    assert_redirected_to admin_snippet_path(assigns(:snippet))
  end
  
  def test_should_destroy_snippet
    old_count = Snippet.count
    delete :destroy, :id => 1
    assert_equal old_count-1, Snippet.count
    
    assert_redirected_to snippets_path
  end
end
