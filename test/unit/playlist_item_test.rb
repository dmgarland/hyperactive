require 'test_helper'

class PlaylistItemTest < ActiveSupport::TestCase

  def test_simple_validations
    assert_valid_value PlaylistItem, :uri, "http://superfoo.com:8000/stream"
  end

  test "belongs to a collective" do
    playlist_item = PlaylistItem.new
    assert playlist_item.respond_to?("collective")
  end

  test "must belong to a collective" do
    collective = Collective.first
    playlist_item = PlaylistItem.new(:uri => "http://superfoo.com/bar.mp3")
    assert !playlist_item.valid?
    playlist_item.collective = collective
    assert playlist_item.valid?
  end

end

