require File.dirname(__FILE__) + '/../test_helper'

class UserTest < Test::Unit::TestCase
  fixtures :users

  # Test that a valid user is valid
  def test_valid_user
    user = users(:marcos)
    assert_valid user
  end
end
