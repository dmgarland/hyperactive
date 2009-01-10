require 'test/test_helper'

class ExternalFeedsControllerTest < ActionController::TestCase

  fixtures :external_feeds, :collectives

  def test_should_get_index
    get :index, {:group_id => collectives(:indy_london).id}, as_user(:registered_user)
    assert assigns(:external_feeds)
    assert assigns(:group)
    assert_response :success
  end

  def test_should_get_new
    get :new, {:group_id => collectives(:indy_london).id}, as_user(:registered_user)
    assert_response :success
  end

  def test_should_create_external_feed
    assert_difference('ExternalFeed.count') do
      post :create,  {:external_feed => {:title=> "foo feed", :url => "http://www.indymedia.org.uk/en/promotednewswire.rss", :summary => "foo foo foo" }, :group_id => collectives(:indy_london).id}, as_user(:registered_user)
    end

    assert_redirected_to group_external_feeds_path(assigns(:group))
  end

  def test_should_get_edit
    get :edit, {:id => external_feeds(:one).id, :group_id => collectives(:indy_london).id}, as_user(:registered_user)
    assert_response :success
  end

  def test_should_update_external_feed
    put :update, {:group_id => collectives(:indy_london).id, :id => external_feeds(:one).id, :external_feed => {:title => "foo feed" }}, as_user(:registered_user)
    assert_redirected_to group_external_feeds_path(assigns(:group))
  end

  def test_should_destroy_external_feed
    assert_difference('ExternalFeed.count', -1) do
      delete :destroy, {:id => external_feeds(:one).id, :group_id => collectives(:indy_london).id}, as_user(:registered_user)
    end

    assert_redirected_to group_external_feeds_path(assigns(:group))
  end
  
end
