require 'test_helper'
require File.dirname(__FILE__) + '/content_controller_test'

class OtherMediasControllerTest < ActionController::TestCase
  include ContentControllerTest
  fixtures :content
  
  def setup
    @first_id = content(:othermedia1).id
    @hidden_id = content(:hidden_othermedia).id
  end
  
  def test_create
    assert_difference("OtherMedia.count") do 
      post :create, :content => {
                                :title => "Test content",
                                :summary => "This is a test",
                                :published_by => "Yoss", 
                                :place => "London",
                                :collective_id => collectives(:indy_london).id
                              }
    end
    
    content = model_class.find_by_title("Test content")
    assert_redirected_to other_media_path(assigns(:content))
    assert_equal "published", content.moderation_status    
    assert assigns(:content).collective == collectives(:indy_london)
  end
  
  def test_update_works_for_admin
    post :update, {:id => @first_id, :content => {:title => "Updated title"}}, as_user(:marcos)
    assert_redirected_to :action => "show"  
  end       
  
  def test_archives
    get :archives
    assert_response :success
    assert_template 'archives'
    assert_not_nil assigns(:content)
    assert_equal 6, assigns(:content).size
  end      
  
  
  # A bunch of the tests we don't need to worry about since OtherMedia have 
  # no OpenStreetMapInfo, Comments, etc.
  
  def test_updating_open_street_map_info
    true   
  end     
  
  def test_create_with_open_street_map_info
    true
  end 
  
  def test_create_comment_does_not_work_on_hidden_content
    true
  end
  
  protected 
  
  def model_class
    OtherMedia
  end  
  
end
