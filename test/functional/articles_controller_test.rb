require File.dirname(__FILE__) + '/../test_helper'
require File.dirname(__FILE__) + '/content_controller_test'
require 'articles_controller'

# Re-raise errors caught by the controller.
class ArticlesController; def rescue_action(e) raise e end; end

class ArticlesControllerTest < Test::Unit::TestCase
  
  include ContentControllerTest
  fixtures :content
  
  def setup
    @controller = ArticlesController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    @first_id = content(:article1).id
    @hidden_id = content(:hidden_article).id
  end
  
  def test_admin_controls_by_non_content_owner_not_part_of_collective_should_return_report_controls
    get :admin_controls, {:id => 10}, as_user(:registered_user_3)
    assert_response :success
    assert_template '_report_this_controls'
  end        

  def test_admin_controls_by_content_owner_should_return_admin_controls
    get :admin_controls, {:id => 10}, as_user(:registered_user)
    assert_response :success
    assert_template '_admin_controls'
  end          
  
  def model_class
    Article
  end

end
