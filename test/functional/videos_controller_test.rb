require File.dirname(__FILE__) + '/../test_helper'
require File.dirname(__FILE__) + '/content_controller_test'
require 'videos_controller'

# Re-raise errors caught by the controller.
class VideosController; def rescue_action(e) raise e end; end

class VideosControllerTest < Test::Unit::TestCase

  include ContentControllerTest
  
  fixtures :content
  
  def setup
    @controller = VideosController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    @first_id = content(:first_video).id
    @hidden_id = content(:hidden_video).id
  end

  def test_create
    num_content = model_class.count
    
    post :create, :content => {
                              :title => "Test content",
                              :file => upload("test/fixtures/fight_test.wmv"),
                              :summary => "This is a test",
                              :published_by => "Yoss", 
                              :place => "London" 
                            }, 
                  :tags => "foo bar",
                  :place_tags => ""
    
    content = model_class.find_by_title("Test content")
    assert_equal "Test content", content.title
    assert_match("foo", content.tag_list)
#    assert_match("bar", content.tag_list)
    assert_response :redirect
    assert_redirected_to :action => 'show'
    assert_equal num_content + 1, model_class.count
  end    
  
  
  def model_class
    Video
  end

  
end
