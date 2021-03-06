require File.dirname(__FILE__) + '/../test_helper'
require File.dirname(__FILE__) + '/content_controller_test'
require 'events_controller'
require 'fileutils'

# Re-raise errors caught by the controller.
class EventsController; def rescue_action(e) raise e end; end

class EventsControllerTest < Test::Unit::TestCase

  include ContentControllerTest

  fixtures :content, :open_street_map_infos

  def setup
    @controller = EventsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    @first_id = content(:a_birthday).id
    @hidden_id = content(:hidden_event).id
  end

  def test_index
    get :index
    assert_response :success
    assert_template 'index'
    assert_not_nil assigns(:content)
  end

  def test_index_iphone
    get :index, {:format => "iphone"}
    assert_response :success
    assert_template 'index'
    assert_not_nil assigns(:content)
    assert_equal 3, assigns(:content).size
  end

  def test_list_by_day
    get :list_by_day
    assert_response :success
    assert_template 'list_by_day'
    assert_not_nil assigns(:content)
  end

  # There should be one event on 1994-1-1.
  def test_list_by_day_with_date
    get :list_by_day, :date => "2006-2-23"
    assert_response :success
    assert_template 'list_by_day'
    assert_not_nil assigns(:content)
    assert_equal 2, assigns(:content).size
  end

  # Hidden events shouldn't be shown.
  def test_list_by_day_shouldnt_show_hidden
    get :list_by_day, :date => "2005-01-01"
    assert_response :success
    assert_template 'list_by_day'
    assert_not_nil assigns(:content)
    assert_equal 0, assigns(:content).size
  end

  def test_list_by_event_group
    get :list_by_event_group, :id => @first_id
    assert_response :success
    assert_template 'list_by_event_group'
    assert_not_nil assigns(:content)
  end

  def test_list_by_month
    get :list_by_month
    assert_response :success
    assert_template 'list_by_month'
    assert_not_nil assigns(:content)
  end

  def test_list_calendar_month
    get :calendar_month
    assert_response :success
    assert_template 'calendar_month'
    assert_not_nil assigns(:content)
    assert_not_nil assigns(:content).to_a.length > 0
    get :calendar_month, :date =>  '2007-08-27'
    assert_response :success
    assert_template 'calendar_month'
    assert_not_nil assigns(:content)
    assert_not_nil assigns(:content).to_a.length > 0
  end

  # There should be two fixtures in the month 2006-2.
  def test_list_by_month_with_date
    get :list_by_month, :date => "2006-2-23"
    assert_response :success
    assert_template 'list_by_month'
    assert_not_nil assigns(:content)
    assert_equal 2, assigns(:content).size
  end

  def test_list_by_week
    get :list_by_week
    assert_response :success
    assert_template 'list_by_week'
    assert_not_nil assigns(:content)
  end

  # There should be one fixture in the week 2006-2-22.
  def test_list_by_week_with_date
    get :list_by_week, :date => "1994-1-1"
    assert_response :success
    assert_template 'list_by_week'
    assert_not_nil assigns(:content)
    assert_equal 1, assigns(:content).size
  end

  def test_list_seven_days
    get :list_seven_days
    assert_response :success
    assert_template 'list_seven_days'
    assert_not_nil assigns(:content)
  end

  # There should be two fixtures in the week 2006-2-22.
  def test_list_seven_days_with_date
    get :list_seven_days, :date => "2006-2-22"
    assert_response :success
    assert_template 'list_seven_days'
    assert_not_nil assigns(:content)
    assert_equal 2, assigns(:content).size
  end

  def test_create_event_repeat_simple
    num_events = Event.count
    post :create, :content => {
                              :title => "A test multiple event",
                              :date => DateTime.new(2010, 5, 1),
                              :body => "This should repeat",
                              :summary => "A summary",
                              :published_by => "Yoss",
                              :place => "London",
                            },

                            :event_repeat_type => "repeat_simple",
                            :event_repeats_every => "1",
                            :event_repeats_dwm => "week",
                            :date => {:year => 2010, :month => 6, :day => 15 },
                            :tags => "foo bar",
                            :place_tags => "london brixton"

    assert_response :redirect
    assert_redirected_to :action => "show"
    assert_equal num_events + 7, Event.count
    original_event = Event.find(:first, :conditions => ['title = ?', "A test multiple event"])
    get :show, :id => original_event
    assert_response :success
    assert_match "foo", original_event.tag_list
    assert_match "bar", original_event.tag_list
    assert_match "brixton", original_event.place_tag_list
    assert_match "london", original_event.place_tag_list
    duplicate_events = Event.find(:all, :conditions => ['title = ?', "A test multiple event"])
    assert_equal 7, duplicate_events.length
    duplicate_events.each do |duplicate_event|
      assert_equal "A test multiple event", duplicate_event.title
      assert_match "foo", duplicate_event.tag_list
      assert_match "bar", duplicate_event.tag_list
      assert_match "brixton", duplicate_event.place_tag_list
      assert_match "london", duplicate_event.place_tag_list
      assert duplicate_event.belongs_to_event_group?, "Event should belong to EventGroup."
      assert_equal duplicate_event.date.hour, original_event.date.hour
      assert_equal duplicate_event.date.min, original_event.date.min
    end
  end

  def test_create_post_repeat_complex
    num_events = Event.count
    post :create, :content => {
                              :title => "A test multiple event",
                              :date => DateTime.new(2010, 5, 1),
                              :body => "This should repeat",
                              :summary => "A summary",
                              :published_by => "Yoss",
                              :place => "London",

                            },

                            :event_repeat_type => "repeat_complex",
                            :event_repeats_which_week => "second",
                            :event_repeats_week_day => "Wednesday",
                            :event_repeat_period => 1,
                            :date => {:year => 2010, :month => 8, :day => 15},
                            :tags => "",
                            :place_tags => ""

    assert_response :redirect
    assert_redirected_to :action => "show"
    assert_equal num_events + 5, Event.count
  end

  def test_edit_without_being_logged_in
    get :edit, :id => @first_id
    assert_login_necessary
  end

  def test_edit
    get :edit, {:id => @first_id}, as_user(:marcos)
    assert_template 'edit'
    assert_equal "The Birthday", assigns(:content).title
    assert assigns(:content).valid?
  end

  def test_edit_as_registered_fails_if_not_content_owner
    get :edit, {:id => @first_id}, as_user(:hider_user)
    assert_security_error
  end

  def test_edit_as_registered_when_content_owner
    get :edit, {:id => content(:zapatista_uprising).id}, as_user(:registered_user)
    assert_response :success
    assert_template 'edit'
    assert_equal "The Zapatista Uprising", assigns(:content).title
    assert assigns(:content).valid?
  end

  def test_update
    post :update, event_stub(@first_id), as_user(:marcos)
    event = Event.find_by_title("A Changed Event")
    assert_match("bah", event.tag_list)
    assert_match(/blah/, event.tag_list)
    assert_no_match(/bar_tag/, event.tag_list)
    assert_no_match(/foo_tag/, event.tag_list)
    assert event.taggings.map(&:event_date).include?(event.date)
    assert_response :redirect
    assert_redirected_to :action => 'show', :id => @first_id
    assert_equal "A Changed Event", assigns(:content).title
  end

  def test_update_as_registered_fails_if_not_content_owner
    post :update, event_stub(@first_id), as_user(:hider_user)
    assert_security_error
  end

  def test_update_as_registered_when_content_owner
    post :update, event_stub(@first_id), as_user(:registered_user)
    assert_response :redirect
    assert_redirected_to :action => 'show', :id => @first_id
    assert_equal "A Changed Event", assigns(:content).title
  end

  def test_update_as_anonymous_fails
    post :update, event_stub(content(:a_birthday).id)
    assert_login_necessary
  end

  def test_destroy
    assert_not_nil Event.find(content(:a_birthday).id)

    post :destroy, {:id => content(:a_birthday).id}, as_user(:marcos)
    assert_response :redirect
    assert_redirected_to :action => 'index'

    assert_raise(ActiveRecord::RecordNotFound) {
      Event.find(content(:a_birthday).id)
    }
  end

  def test_destroy_as_registered_should_fail
    e = Event.find(content(:a_birthday).id)
    assert_not_nil(e)

    post :destroy, {:id => content(:a_birthday).id}, as_user(:registered_user)
    assert_security_error

    e2 = Event.find(content(:a_birthday).id)
    assert_equal(e, e2)
  end

  def test_destroy_as_anonymous_should_fail
    e = Event.find(content(:a_birthday).id)
    assert_not_nil(e)

    post :destroy, {:id => content(:a_birthday).id}
    assert_login_necessary

    e2 = Event.find(content(:a_birthday).id)
    assert_equal(e, e2)
  end

  def test_ical_download
    get :ical_download, {:id => content(:a_birthday).id}
    assert_response :success
    assert assigns(:content)
    assert_match(/#{assigns(:content).title}/, @response.body, "Expected to find a match between the content title and the ical text.")
    #assert_no_match(/<p>/, @response.body, "The HTML tags should have been stripped.")
  end

  def test_showing_open_street_map_info_should_work
    get :show, {:id => @first_id}
    assert_response :success
    assert assigns(:content)
    assert_match /#{assigns(:content).open_street_map_info.lat}/, @response.body, "Expected to have this event's latitude in the page body."
  end

  def test_list_promoted
    get :promoted
    assert_response :success
    assert_template 'promoted'
    assert_not_nil assigns(:content)
    assert_equal 1, assigns(:content).size,
      "There should be 1 promoted upcoming event in the fixtures."
  end

  def test_list_promoted_iphone
    get :promoted, :format => "iphone"
    assert_response :success
    assert_template 'promoted'
    assert_not_nil assigns(:content)
    assert_equal 1, assigns(:content).size,
      "There should be 1 promoted upcoming event in the fixtures."
  end

  def event_stub(id)
    {
      :id => id,
      :content => {
                :title => "A Changed Event",
                :date => DateTime.new(2007, 5, 1),
                :body => "This event has been changed.",
                :published_by => "Yoss",
                :place => "London",

              },
      :tags => "bah blah",
      :place_tags => "London Brixton"

    }
  end

  def model_class
    Event
  end

end

