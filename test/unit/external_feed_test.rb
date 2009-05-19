require 'test/test_helper'

class ExternalFeedTest < ActiveSupport::TestCase

  def test_validation
    assert_invalid_value(ExternalFeed, :title, [nil, ""])
    assert_invalid_value(ExternalFeed, :url, [nil, ""])
  end

end
