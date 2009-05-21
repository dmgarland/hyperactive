require File.dirname(__FILE__) + '/../../test_helper'
require 'admin/pages_controller'

# Re-raise errors caught by the controller.
class Admin::PagesController; def rescue_action(e) raise e end; end

class Admin::PagesControllerTest < Test::Unit::TestCase
  fixtures :pages

  def setup
    @controller = Admin::PagesController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    @id = pages(:about).id
  end

  def test_index
    get :index, {}, as_user(:marcos)
    assert_response :success
    assert_template 'index'
    assert_not_nil assigns(:pages)
  end



  def test_show
    get :show, {:id => @id}, as_user(:marcos)

    assert_response :success
    assert_template 'show'

    assert_not_nil assigns(:page)
    assert assigns(:page).valid?
  end

  def test_new
    get :new, {}, as_user(:marcos)

    assert_response :success
    assert_template 'new'

    assert_not_nil assigns(:page)
  end

  def test_create
    num_pages = Page.count

    post :create, {:page => {:title => "A title", :body => "A body"}}, as_user(:marcos)

    assert_response :redirect
    assert_redirected_to admin_page_path(assigns(:page))

    assert_equal num_pages + 1, Page.count
  end

  def test_edit
    get :edit, {:id => @id}, as_user(:marcos)

    assert_response :success
    assert_template 'edit'

    assert_not_nil assigns(:page)
    assert assigns(:page).valid?
  end

  def test_update
    post :update, {:id => @id}, as_user(:marcos)
    assert_response :redirect
    assert_redirected_to admin_page_path(assigns(:page))
  end

  def test_destroy
    assert_not_nil Page.find(@id)

    post :destroy, {:id => @id}, as_user(:marcos)
    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_raise(ActiveRecord::RecordNotFound) {
      Page.find(@id)
    }
  end
end
