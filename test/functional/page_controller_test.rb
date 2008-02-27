require File.dirname(__FILE__) + '/../test_helper'
require 'page_controller'

# Re-raise errors caught by the controller.
class PageController; def rescue_action(e) raise e end; end

class PageControllerTest < Test::Unit::TestCase
  def setup
    @controller = PageController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_show
    get :show, :title => 'About the site'

    assert_response :success
    assert_template 'show'

    assert_not_nil assigns(:page)
    assert assigns(:page).valid?
  end
end
