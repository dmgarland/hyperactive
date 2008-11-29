require 'test/test_helper'

class ContentFilterExpressionTest < ActiveSupport::TestCase
  
  def test_validation
    assert_invalid_value(ContentFilterExpression, :regexp, [nil, ""])
  end
  
end
