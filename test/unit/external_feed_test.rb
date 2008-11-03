require 'test/test_helper'

class ExternalFeedTest < ActiveSupport::TestCase

  def test_validation
    assert_invalid_value(ExternalFeed, :title, [nil, ""])
    assert_invalid_value(ExternalFeed, :url, [nil, ""])
    #assert_valid_value(ExternalFeed, :title => "foo")
    #assert_valid_value(ExternalFeed, :url => "http://www.indymedia.org.uk/en/promotednewswire.rss")
  end

end
