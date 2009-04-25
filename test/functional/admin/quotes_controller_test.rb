require File.dirname(__FILE__) + '/../../test_helper'

class Admin::QuotesControllerTest < ActionController::TestCase
  
  fixtures :quotes
  
  def test_should_get_index
    get :index, {}, as_user(:marcos)
    assert_response :success
    assert_not_nil assigns(:quotes)
  end

  def test_should_get_new
    get :new, {}, as_user(:marcos)
    assert_response :success
  end

  def test_should_create_quote
    assert_difference('Quote.count') do
      post :create, {:quote => {:body => "foo"}}, as_user(:marcos)
    end

    assert_redirected_to admin_quote_path(assigns(:quote))
  end

  def test_should_show_quote
    get :show, {:id => quotes(:one).id}, as_user(:marcos)
    assert_response :success
  end

  def test_should_get_edit
    get :edit, {:id => quotes(:one).id}, as_user(:marcos)
    assert_response :success
  end

  def test_should_update_quote
    put :update, {:id => quotes(:one).id, :quote => { }}, as_user(:marcos)
    assert_redirected_to admin_quote_path(assigns(:quote))
  end

  def test_should_destroy_quote
    assert_difference('Quote.count', -1) do
      delete :destroy, {:id => quotes(:one).id}, as_user(:marcos)
    end

    assert_redirected_to admin_quotes_path
  end
end
