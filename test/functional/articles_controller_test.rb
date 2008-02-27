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
  
  def model_class
    Article
  end

end
