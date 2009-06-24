require File.dirname(__FILE__) + '/../test_helper'

class CollectiveTest < Test::Unit::TestCase
  fixtures :collectives

  def test_validation
    assert_invalid_value(Collective, :name, [nil, ""])
    assert_invalid_value(Collective, :summary, [nil, ""])
  end

  def test_upcoming_events
    @indy_london = collectives(:indy_london)
    assert_equal 3, @indy_london.events.length
    assert_equal 1, @indy_london.upcoming_events.length, "There should only be 1 upcoming event"
  end

  def test_recently_active
    indy_london = collectives(:indy_london)
    other_collective = collectives(:two)
    indy_london.moderation_status = "promoted"
    other_collective.moderation_status = "promoted"
    other_collective.save!
    indy_london.save!

    o = Video.new(:title => "foo", :summary => "bar", :file => fixture_file_upload("fight_test.wmv"), :published_by => "blah")
    o.collective = indy_london
    o.save!
    assert_equal Collective.recently_active.first, indy_london,
      "indy_london should be the most recently_active collective"

    o = Video.new(:title => "foo", :summary => "bar", :file => fixture_file_upload("fight_test.wmv"), :published_by => "blah")
    o.collective = other_collective
    o.save!
    assert_equal other_collective.moderation_status, indy_london.moderation_status
    assert_equal other_collective, Collective.recently_active.first,
      "the other collective should now be the most recently active"
  end

  def test_featured_collective_takes_precedence_over_recently_active_published_collective
    indy_london = collectives(:indy_london)
    other_collective = collectives(:two)

    o = Video.new(:title => "foo", :summary => "bar", :file => fixture_file_upload("fight_test.wmv"), :published_by => "blah")
    o.collective = indy_london
    o.save!
    recently_active = Collective.recently_active
    assert_equal recently_active.first, indy_london

    o = Video.new(:title => "foo", :summary => "bar", :file => fixture_file_upload("fight_test.wmv"), :published_by => "blah")
    o.collective = other_collective
    o.save!
    assert_equal indy_london, Collective.recently_active.first, "the indy_london collective should still be the most recently active because it's featured"
  end

  def test_update_to_collective_content_updates_collective_timestamp
    indy_london = collectives(:indy_london)
    start_time = indy_london.updated_on
    indy_london.events.first.title = "A new title"
    indy_london.events.first.save!
    indy_london.reload
    assert_not_equal indy_london.updated_on, start_time
  end

end

