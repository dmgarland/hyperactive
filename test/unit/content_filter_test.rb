require 'test/test_helper'

class ContentFilterTest < ActiveSupport::TestCase

  def test_validation
    assert_invalid_value(ContentFilter, :title, [nil, ""])
    assert_invalid_value(ContentFilter, :summary, [nil, ""])   
  end
  
  def test_association_of_content_filter_expressions
    
  end

end
