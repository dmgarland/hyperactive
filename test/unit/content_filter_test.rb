require 'test/test_helper'

class ContentFilterTest < ActiveSupport::TestCase

  def test_validation
    assert_invalid_value(ContentFilter, :title, [nil, ""])
    assert_invalid_value(ContentFilter, :summary, [nil, ""])   
  end
  
  def test_association_of_content_filter_expressions
    content_filter = ContentFilter.new(:title => "foo", :summary => "bar")
    content_filter_exp = ContentFilterExpression.new(:summary => "foo_exp", :regexp => "bar_exp")
    content_filter.content_filter_expressions << content_filter_exp
    content_filter.save!
    assert_same content_filter.content_filter_expressions.first, content_filter_exp
  end

end
