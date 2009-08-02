require 'test_helper'

class OtherMediaTest < ActiveSupport::TestCase

  test "must have a source" do
    o = OtherMedia.new(:title => "foo", :summary => "bar", :published_by => "blah")
    assert !o.valid?
    o.source = "http://foo.org"
    assert o.valid?
  end

end

