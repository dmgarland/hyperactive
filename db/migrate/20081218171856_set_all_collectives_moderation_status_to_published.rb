class SetAllCollectivesModerationStatusToPublished < ActiveRecord::Migration
  def self.up
    collectives = Collective.all
    collectives.each do |c|
      c.moderation_status = "published"
      c.save
    end
  end

  def self.down
  end
end
