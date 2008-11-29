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
  
  def test_destroying_content_filter_should_destroy_expressions_too
    content_filter = ContentFilter.new(:title => "foo33", :summary => "bar")
    content_filter_exp = ContentFilterExpression.new(:summary => "foo_exp33", :regexp => "bar_exp")
    content_filter.content_filter_expressions << content_filter_exp
    content_filter.save!
    assert_same content_filter.content_filter_expressions.first, content_filter_exp
    cf = ContentFilter.find_by_title("foo33")
    cf.destroy
    assert_equal nil, ContentFilterExpression.find_by_summary("foo_exp33"), "Content filter expression should be destroyed when parent ContentFilter is destroyed."
  end  

end
