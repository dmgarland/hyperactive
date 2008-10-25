require File.dirname(__FILE__) + '/../test_helper'
require 'search_controller'

# Re-raise errors caught by the controller.
class SearchController; def rescue_action(e) raise e end; end

class SearchControllerTest < Test::Unit::TestCase

  fixtures :content, :tags, :taggings, :place_tags, :place_taggings

  def setup
    @controller = SearchController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    Event.rebuild_index
  end
  
  # Searching by a tag should work.
  def test_by_tag
    get :by_tag, {:scope => 'bar_tag', :date => Date.new(2005)}
    assert_response :success
    assert_template 'by_tag'
    assert_match(/Tagged with &lsquo;bar_tag&rsquo;/, @response.body)
    assert_match(/The Birthday/, @response.body)
  end
  
  # Tags are searched based on a date parameter or starting from the present day
  # if one isn't supplied. The first fixture defined has an event.date in the past, 
  # so it shouldn't show up in a default tag search.  In this case, the template gets
  # back an empty @events array.
  def test_by_tag_for_past_event
    get :by_tag, :scope => 'bar_tag'
    assert_response :success
    assert_template 'by_tag'
    assert_not_nil assigns(:content)
    #assert_match(/There are events for this tag, but they're in the past./, @response.body)           
  end
  
  # Searching by a nonexistent tag should work but give a nice message saying tag not found.
  def test_by_tag_when_tag_doesnt_exist
    get :by_tag, :scope => 'nonexistent_tag'
    assert_response :success
    assert_template 'by_tag'
    assert_nil assigns(:content)
    assert_match(/Nothing has been tagged with/, @response.body)       
  end
  
  # Searching for a PlaceTag should work.
  def test_by_place_tag
    get :by_place_tag, {:scope => 'stockwell_tag', :date => Date.new(2005)}
    assert_response :success
    assert_template 'by_place_tag'
    assert_not_nil assigns(:content)
    assert_match(/stockwell/, @response.body)
  end

  # PlaceTags are searched based on a date parameter or starting from the present day
  # if one isn't supplied. The first fixture defined has an event.date in the past, 
  # so it shouldn't show up in a default place_tag search.  In this case, the template gets
  # back an empty @content array.  
  def test_by_place_tag_for_past_event
    get :by_place_tag, :scope => 'stockwell_tag'
    assert_response :success
    assert_template 'by_place_tag'
    assert_not_nil assigns(:content)
    #assert_match(/There are events for this tag, but they're in the past./, @response.body)            
  end
  
  # Searching by a nonexistent PlaceTag should work but give a nice message saying tag not found.  
  def test_by_place_tag_for_nonexistent_place
    get :by_place_tag, :scope => 'nonexistentplace'
    assert_response :success
    assert_template 'by_place_tag'
    assert_nil assigns(:content)
    assert_match(/Nothing has been tagged with/, @response.body)      
  end

  def test_find_content
    get :find_content, :search => {:search_terms => "london"}
    assert_response :success
    assert_template 'find_content'
    assert_not_nil assigns(:events)
    assert_equal 3, assigns(:events).size, "There should be 3 events returned when searching for London."
  end
  
  def test_find_content_with_nonexistent_search_term
    get :find_content, :search => {:search_terms => "jkjkjkjkj"}
    assert_response :success
    assert_template 'find_content'
    assert_not_nil assigns(:articles)
    assert_equal 0, assigns(:articles).size, "There should be no events returned when searching for a nonexistent search term." 
  end
  
  def test_search_shouldnt_return_hidden_content
    get :find_content, :search => {:search_terms => "hidden"}
    assert_response :success
    assert_template 'find_content'
    assert_not_nil assigns(:events)
    assert_equal 0, assigns(:events).size, "There should be no events returned when searching for events that are hidden."     
  end
  
   # This is temporarily disabled as there is no such thing as unpublished content.
   #
#  def test_search_shouldnt_return_unpublished_content
#    get :find_content, :search => {:search_terms => "unpublished"}
#    assert_response :success
#    assert_template 'find_content'
#    assert_not_nil assigns(:content)
#    assert_equal 0, assigns(:content).size, "There should be no events returned when searching for events that are not published."     
#  end  

#  This test is disabled because I haven't done any work on returning only
#  future events (search is now for all Content types rather than just events)
#
#  def test_search_shouldnt_return_past_events
#    get :find_events, :search => {:search_terms => "past"}
#    assert_response :success
#    assert_template 'find_events'
#    assert_not_nil assigns(:content)
#    assert_equal 0, assigns(:content).size, "There should be no events returned when searching for events that are in the past."     
#  end     
  
end

