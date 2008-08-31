require File.dirname(__FILE__) + '/../test_helper'

class <%= controller_class_name %>ControllerTest < ActionController::TestCase
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:<%= table_name %>)
  end

  def test_should_show_<%= file_name %>
    get :show, :id => <%= table_name %>(:one).id
    assert_response :success
  end

end
