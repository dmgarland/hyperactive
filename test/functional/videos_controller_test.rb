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
    
    # Ok, file uploads aren't working tests.  Try this:
    # @file = UploadColumn::UploadedFile.upload(stub_file('kerb.jpg'), record, :avatar)
    # which was ripped from the upload_column specs.
    #    
    post :create, :content => {
                              :title => "Test content",
                              #:file => upload("test/fixtures/fight_test.wmv"),
                              :summary => "This is a test",
                              :published_by => "Yoss", 
                              :place => "London" 
                            }, 
                  :tags => "foo bar, blah",
                  :place_tags => "london, brixton"
    
    content = model_class.find_by_title("Test content")
    assert_equal "Test content", content.title
    assert_match("foo", content.tag_list)
    assert_match("bar", content.tag_list)
    assert_match("london", content.place_tag_list)
    assert_match("brixton", content.place_tag_list)
    assert_no_match(/,/, content.tag_list) 
    assert_no_match(/,/, content.place_tag_list)
    assert_response :redirect
    assert_redirected_to :action => 'show'
    assert_equal num_content + 1, model_class.count
    assert_equal "published", content.moderation_status    
  end    
  
  def test_moderation_status_retained_when_specifically_set_at_creation
    num_content = model_class.count
    
    post :create, :content => {
                              :title => "Test content",
                              #:file => upload("test/fixtures/fight_test.wmv"),
                              :summary => "This is a test",
                              :moderation_status => "promoted",
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
    assert_equal "promoted", content.moderation_status    
  end  
  
  def test_update_works_for_content_owner
    post :update, {:id => @first_id, :content => {:title => "Updated title", :file => ""}, :tags => "", :place_tags => ""}, as_user(:registered_user)
    assert_redirected_to :action => "show"   
  end

  def test_update_works_for_content_collective_member
    post :update, {:id => @first_id, :content => {:title => "Updated title", :file => ""}, :tags => "", :place_tags => ""}, as_user(:registered_user_2)
    assert_redirected_to :action => "show"   
  end  
  
  def test_update_works_for_admin
    post :update, {:id => @first_id, :content => {:title => "Updated title", :file => ""}, :tags => "", :place_tags => ""}, as_user(:marcos)
    assert_redirected_to :action => "show"  
  end    
  
  def test_update_does_not_work_for_non_collective_member
    post :update, {:id => @first_id, :content => {:title => "Updated title", :file => ""}, :tags => "", :place_tags => ""}, as_user(:hider_user)
    assert_security_error
  end  
  
  def model_class
    Video
  end

  
end
