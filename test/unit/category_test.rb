require File.dirname(__FILE__) + '/../test_helper'

class CategoryTest < Test::Unit::TestCase
  fixtures :categories

  # Name and description are required.
  def test_required_fields
    assert_invalid_value(Category, :name, [nil, "", "a"])
    assert_valid_value(Category, :name, ["foo","blahblahblah a title"])
    assert_invalid_value(Category, :description, [nil, "", "a", "aaa aaa a"])
    assert_valid_value(Category, :description, ["A category description"])
  end
end
