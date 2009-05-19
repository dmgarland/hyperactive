require File.dirname(__FILE__) + '/../test_helper'

class ContentHideMailerTest < Test::Unit::TestCase
  
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
    
    @content = content(:a_birthday)
    @user = users(:marcos)
    @reasons = "Email hiding or unhiding reasons"
  end

  def test_hide
    response = ContentHideMailer.create_hide(@content, @reasons, @user)
    assert_equal response.subject, "Content Hidden"
    assert_match(/"The Birthday"/, response.body)
    assert_match(/marcos/, response.body)
    assert_match(/1/, response.body)
  end

  def test_report
    response = ContentHideMailer.create_report(@content, @reasons, @user)
    assert_equal response.subject, "Problem reported with content"
    assert_match(/"The Birthday"/, response.body)
    assert_match(/marcos/, response.body)
    assert_match(/1/, response.body)
  end


  def test_unhide
    response = ContentHideMailer.create_unhide(@content, @reasons, @user)
    assert_equal response.subject, "Content Unhidden"
    assert_match(/"The Birthday"/, response.body)
    assert_match(/marcos/, response.body)
    assert_match(/1/, response.body)
  end

  private
    def read_fixture(action)
      IO.readlines("#{FIXTURES_PATH}/content_hide_mailer/#{action}")
    end

    def encode(subject)
      quoted_printable(subject, CHARSET)
    end
end
