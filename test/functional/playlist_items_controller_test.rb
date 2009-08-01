require 'test_helper'

class PlaylistItemsControllerTest < ActionController::TestCase

  fixtures :playlist_items

  test "should get index" do
    get :index, {:group_id => collectives(:indy_london).id}, as_user(:registered_user)
    assert_response :success
    assert_not_nil assigns(:playlist_items)
  end

  test "should get new" do
    get :new, {:group_id => collectives(:indy_london).id}, as_user(:registered_user)
    assert_response :success
  end

  test "should create playlist_item" do
    assert_difference('PlaylistItem.count') do
      post :create, {:playlist_item => {:uri => "http://foo.com:8000/stream", :title => "foo stream" }, :group_id => collectives(:indy_london).id}, as_user(:registered_user)
    end

    assert_redirected_to group_playlist_item_path(assigns(:group), assigns(:playlist_item))
  end

  test "should show playlist_item" do
    get :show, :id => playlist_items(:one).id, :group_id => collectives(:indy_london).id
    assert_response :success
  end

  test "should get edit" do
    get :edit, {:id => playlist_items(:one).id, :group_id => collectives(:indy_london).id}, as_user(:registered_user)
    assert_response :success
  end

  test "should update playlist_item" do
    put :update, {:id => playlist_items(:one).id, :playlist_item => {:uri => "http://foo2.com:8000/stream" }, :group_id => collectives(:indy_london).id}, as_user(:registered_user)
    assert_redirected_to group_playlist_item_path(assigns(:group), assigns(:playlist_item))
  end

  test "should destroy playlist_item" do
    assert_difference('PlaylistItem.count', -1) do
      delete :destroy, {:id => playlist_items(:one).id, :group_id => collectives(:indy_london).id}, as_user(:registered_user)
    end

    assert_redirected_to group_playlist_items_path(assigns(:group))
  end
end

