require File.dirname(__FILE__) + '/../test_helper'

class EventHiddenMailerTest < Test::Unit::TestCase
  
  fixtures :content, :users

  FIXTURES_PATH = File.dirname(__FILE__) + '/../fixtures'
  CHARSET = "utf-8"

  include ActionMailer::Quoting

  def setup
    ActionMailer::Base.delivery_method = :test
    ActionMailer::Base.perform_deliveries = false
    ActionMailer::Base.deliveries = []

    @expected = TMail::Mail.new
    @expected.set_content_type "text", "plain", { "charset" => CHARSET }
    @expected.mime_version = '1.0'
    
    @event = Event.find(1)
    @user = User.find(1)
    @reasons = "Email hiding or unhiding reasons"
  end

  def test_hide
    response = EventHiddenMailer.create_hide(@event, @reasons, @user)
    assert_equal response.subject, "Event Hidden"
    assert_match(/The event "The Birthday"/, response.body)
    assert_match(/marcos/, response.body)
    assert_match(/1/, response.body)
  end

  def test_unhide
    response = EventHiddenMailer.create_unhide(@event, @reasons, @user)
    assert_equal response.subject, "Event Unhidden"
    assert_match(/The event "The Birthday"/, response.body)
    assert_match(/marcos/, response.body)
    assert_match(/1/, response.body)
  end

  private
    def read_fixture(action)
      IO.readlines("#{FIXTURES_PATH}/event_hidden_mailer/#{action}")
    end

    def encode(subject)
      quoted_printable(subject, CHARSET)
    end
end