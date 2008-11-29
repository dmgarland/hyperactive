require File.dirname(__FILE__) + '/../../test_helper'

class Admin::ContentFiltersControllerTest < ActionController::TestCase
  
  fixtures :content_filters
  
  def test_should_get_index
    get :index, {}, as_user(:marcos)
    assert_response :success
    assert_not_nil assigns(:content_filters)
  end

  def test_should_get_new
    get :new, {}, as_user(:marcos)
    assert_response :success
  end

  def test_should_create_content_filter
    assert_difference('ContentFilter.count') do
      post :create, {:content_filter => {:title => "foo", :summary => "bar" }}, as_user(:marcos)  
    end

    assert_redirected_to admin_content_filter_path(assigns(:content_filter))
  end

  def test_should_show_content_filter
    get :show, {:id => content_filters(:one).id}, as_user(:marcos)
    assert_response :success
  end

  def test_should_get_edit
    get :edit, {:id => content_filters(:one).id}, as_user(:marcos)
    assert_response :success
  end

  def test_should_update_content_filter
    put :update, {:id => content_filters(:one).id, :content_filter => { }}, as_user(:marcos)
    assert_redirected_to admin_content_filter_path(assigns(:content_filter))
  end

  def test_should_destroy_content_filter
    assert_difference('ContentFilter.count', -1) do
      delete :destroy, {:id => content_filters(:one).id}, as_user(:marcos)
    end

    assert_redirected_to admin_content_filters_path
  end
end
