require 'test_helper'

class ExternalFeedsControllerTest < ActionController::TestCase

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_external_feed
    assert_difference('ExternalFeed.count') do
      post :create, :external_feed => { }
    end

    assert_redirected_to external_feed_path(assigns(:external_feed))
  end

  def test_should_get_edit
    get :edit, :id => external_feeds(:one).id
    assert_response :success
  end

  def test_should_update_external_feed
    put :update, :id => external_feeds(:one).id, :external_feed => { }
    assert_redirected_to external_feed_path(assigns(:external_feed))
  end

  def test_should_destroy_external_feed
    assert_difference('ExternalFeed.count', -1) do
      delete :destroy, :id => external_feeds(:one).id
    end

    assert_redirected_to external_feeds_path
  end
end
