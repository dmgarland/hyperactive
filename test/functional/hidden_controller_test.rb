require File.dirname(__FILE__) + '/../test_helper'
require 'hidden_controller'

# Re-raise errors caught by the controller.
class HiddenController; def rescue_action(e) raise e end; end

# This class tests that the hiding of content works.  In theory we could use some
# more tests here, to take care of each Content subclass, but it may not be worth 
# doing it at this stage.  Note the content_controller_test.rb, which is included
# in all Content subclass tests, does exercise the showing and hiding of all
# Content subclasses, so more may not be necessary here.
#
class HiddenControllerTest < Test::Unit::TestCase
  
  fixtures :content, :event_groups, :users, :roles, :roles_users, :tags, :taggings, :place_tags, :place_taggings

  def setup
    @controller = HiddenController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_index
    get :index
    assert_redirected_to :action => "list"
  end
  
  def test_list
    get :list
    assert_response :success
    assert_template 'list'
    assert_not_nil assigns(:content)
  end
  
  def test_event_hiding_controls_without_being_logged_in
    get :hiding_controls, :id => 1
    assert_template "hidden/report_this_controls", "Users who can't hide should be shown the 'report this' controls"
  end
  
  
  def test_hiding_controls
    get :hiding_controls, {:id => 1}, {:rbac_user_id => users(:marcos).id } 
    assert_response :success
    assert_template 'hiding_controls'
  end
  
  def test_hide_event_without_being_logged_in
    post :hide, :id => 1
    assert_redirected_to :action => "index"
    assert_equal "You are not allowed to access this page.", flash[:notice]
  end  
  
  def test_hide_event
    post :hide, {:id => 1}, {:rbac_user_id => users(:marcos).id }
    event = Event.find(1)
    assert_response :success
    assert_equal event.hidden, true, "Hidden event should be hidden."
    assert_equal "The event has been hidden and an email sent.", flash[:notice]
    event.taggings.each do |tagging|
      assert_equal tagging.hide_tag, true
      assert_equal tagging.hide_tag, event.hidden
    end
    event.place_taggings.each do |place_tagging|
      assert_equal place_tagging.hide_tag, true
      assert_equal place_tagging.hide_tag, event.hidden
    end
  end
  
  def test_event_unhiding_controls_without_being_logged_in
    get :unhiding_controls, {:id => 1}
    assert_template "hidden/unreport_this_controls", "Users who can't hide should be shown the 'unreport this' controls containing a security message."
  end  
  
  def test_event_unhiding_controls
    get :unhiding_controls, {:id => 1}, {:rbac_user_id => users(:marcos).id }
    assert_response :success
    assert_template 'unhiding_controls'    
  end

  def test_unhide_event_without_being_logged_in
    post :unhide_event, {:id => 1}
    assert_redirected_to :action => "index"
    assert_equal "You are not allowed to access this page.", flash[:notice]
  end
  
  def test_unhide_event
    post :unhide, {:id => 1}, {:rbac_user_id => users(:marcos).id }
    event = Event.find(1)
    assert_response :success
    assert_equal event.hidden, false, "Unhidden event should not be hidden."
    assert_equal "The event has been unhidden and an email sent.", flash[:notice]
    event.taggings.each do |tagging|
      assert_equal tagging.hide_tag, false
      assert_equal tagging.hide_tag, event.hidden
    end   
    event.place_taggings.each do |place_tagging|
      assert_equal place_tagging.hide_tag, false
      assert_equal place_tagging.hide_tag, event.hidden
    end
  end
  
  def test_hide_event_group_controls_without_being_logged_in
    get :event_group_hiding_controls, {:id => 1}
    assert_redirected_to :action => "index"
    assert_equal "You are not allowed to access this page.", flash[:notice]    
  end

  def test_hide_event_group_controls
    get :event_group_hiding_controls, {:id => 5}, {:rbac_user_id => users(:marcos).id }
    assert_response :success
    assert_template 'event_group_hiding_controls'  
  end

  def test_hide_event_group_without_being_logged_in
    post :hide_event_group, {:id => 1}
    assert_redirected_to :action => "index"
    assert_equal "You are not allowed to access this page.", flash[:notice]  
  end
  
  def test_hide_event_group
    post :hide_event_group, {:id => 1}, {:rbac_user_id => users(:marcos).id }
    assert_response :success
    event_group = EventGroup.find(1)
    event_group.events.each do |event|
      assert_equal true, event.hidden, "Event should be hidden after EventGroup hide."
    end
  end
  
end
