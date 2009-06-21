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

  fixtures :content, :event_groups, :users, :roles, :roles_users, :tags, :taggings, :place_tags, :place_taggings, :comments

  def setup
    @controller = HiddenController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

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


  def test_comment_hiding_controls_without_being_logged_in
    get :comment_hiding_controls, :id => comments(:one).id
    assert_template "hidden/report_comment_controls", "Users who can't hide should be shown the 'report this' controls"
  end

  def test_comment_hiding_controls
    get :comment_hiding_controls, {:id => comments(:one).id}, as_user(:marcos)
    assert_response :success
    assert_template 'comment_hiding_controls'
  end

  def test_hide_content_without_being_logged_in
    post :hide, :id => content(:a_birthday).id
    assert_login_necessary
  end

  def test_hide_comment_without_being_logged_in
    post :hide_comment, :id => comments(:one).id
    assert_login_necessary
  end

  def test_hide_content
    post :hide, {:id => content(:a_birthday).id}, as_user(:marcos)
    event = Event.find(content(:a_birthday).id)
    assert_response :success
    assert_equal "hidden", event.moderation_status, "Hidden event should be hidden."
    assert_equal "The event has been hidden and an email sent.", flash[:notice]
    event.taggings.each do |tagging|
      assert_equal tagging.hide_tag, true
      assert_equal tagging.hide_tag, event.is_hidden?
    end
    event.place_taggings.each do |place_tagging|
      assert_equal place_tagging.hide_tag, true
      assert_equal place_tagging.hide_tag, event.is_hidden?
    end
  end

  def test_hide_own_content_by_registered_user_should_work
    post :hide, {:id => content(:article1).id}, as_user(:marcos)
    article = Article.find(content(:article1).id)
    assert_response :success
    assert_equal "hidden", article.moderation_status, "Hidden article should be hidden."
    assert_equal "The article has been hidden and an email sent.", flash[:notice]
    article.taggings.each do |tagging|
      assert_equal tagging.hide_tag, true
      assert_equal tagging.hide_tag, article.is_hidden?
    end
  end

  def test_hide_own_content_by_wrong_registered_user_should_not_work
    post :hide, {:id => content(:article1).id}, as_user(:registered_user_3)
    assert_security_error
  end

  def test_unhiding_controls_without_being_logged_in
    get :unhiding_controls, {:id => content(:article1).id}
    assert_template "hidden/unreport_this_controls", "Users who can't hide should be shown the 'unreport this' controls containing a security message."
  end

  def test_unhiding_controls
    get :unhiding_controls, {:id => content(:article1).id}, as_user(:marcos)
    assert_response :success
    assert_template 'unhiding_controls'
  end

  def test_comment_unhiding_controls
    get :comment_unhiding_controls, {:id => comments(:one).id}, as_user(:marcos)
    assert_response :success
    assert_template 'comment_unhiding_controls'
  end

  def test_unhide_event_without_being_logged_in
    post :unhide, {:id => content(:a_birthday).id}
    assert_login_necessary
  end

  def test_unhide_comment_without_being_logged_in
    post :unhide_comment, {:id => comments(:one).id}
    assert_login_necessary
  end

  def test_unhide_event
    post :unhide, {:id => content(:hidden_event).id}, as_user(:marcos)
    event = Event.find(content(:hidden_event).id)
    assert_response :success
    assert_equal event.moderation_status, "published", "Unhidden event should not be hidden."
    assert_equal "The event has been unhidden and an email sent.", flash[:notice]
    event.taggings.each do |tagging|
      assert_equal tagging.hide_tag, false
      assert_equal tagging.hide_tag, event.is_hidden?
    end
    event.place_taggings.each do |place_tagging|
      assert_equal place_tagging.hide_tag, false
      assert_equal place_tagging.hide_tag, event.is_hidden?
    end
  end

  def test_unhide_comment
    post :unhide_comment, {:id => comments(:one).id}, as_user(:marcos)
    comment = comments(:one)
    assert_response :success
    assert_equal comment.moderation_status, "published", "Unhidden comment should not be hidden."
    assert_equal "The comment has been unhidden.", flash[:notice]
  end

  def test_hide_event_group_controls_without_being_logged_in
    get :event_group_hiding_controls, {:id => content(:london_meeting2).id}
    assert_login_necessary
  end

  def test_hide_event_group_controls
    get :event_group_hiding_controls, {:id => content(:london_meeting2).id}, as_user(:marcos)
    assert_response :success
    assert_template 'event_group_hiding_controls'
  end

  def test_hide_event_group_without_being_logged_in
    post :hide, {:id => content(:london_meeting2).id, :hide_all_events_in_event_group => true}
    assert_login_necessary
  end

  def test_hide_event_group
    post :hide, {:id => content(:london_meeting1), :hide_all_events_in_event_group => true}, {:rbac_user_id => users(:marcos).id }
    assert_response :success
    event_group = EventGroup.find(1)
    event_group.events.each do |event|
      assert_equal "hidden", event.moderation_status, "Event should be hidden after EventGroup hide."
    end
  end

  def test_anonymous_user_cannot_promote_content
    content = content(:london_meeting1)
    status = content.moderation_status
    post :promote, {:id => content}
    assert_login_necessary
    assert_equal status, content(:london_meeting1).moderation_status
  end

  def test_admin_user_can_promote_content
    post :promote, {:id => content(:london_meeting1)}, as_user(:marcos)
    assert_response :success
    assert_equal "promoted", assigns(:content).moderation_status
  end

  def test_user_with_promote_permission_can_promote_content
    post :promote, {:id => content(:london_meeting1)}, as_user(:moderator_user)
    assert_response :success
    assert_equal "promoted", assigns(:content).moderation_status
  end

  def test_report
    post :report, {:id => content(:a_birthday).id}
    assert_response :success
  end

end

