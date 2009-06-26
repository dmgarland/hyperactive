require File.dirname(__FILE__) + '/../test_helper'

class UserTest < ActiveSupport::TestCase
  fixtures :users, :content

  # Test that a valid user is valid
  def test_valid_user
    user = users(:marcos)
    assert_valid user
  end

  test "has many articles" do
    user = User.new
    assert user.respond_to?("articles")
    assert_nothing_raised do
      user.articles << content(:article1)
    end
  end

  test "has many events" do
    user = User.new
    assert user.respond_to?("events")
    assert_nothing_raised do
      user.events << content(:zapatista_uprising)
    end
  end


  test "has many other medias" do
    user = User.new
    assert user.respond_to?("other_medias")
    assert_nothing_raised do
      user.other_medias << content(:promoted_othermedia)
    end
  end

  test "has many videos" do
    user = User.new
    assert user.respond_to?("videos")
    assert_nothing_raised do
      user.videos << content(:first_video)
    end
  end

end

