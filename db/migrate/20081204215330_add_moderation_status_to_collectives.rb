class AddModerationStatusToCollectives < ActiveRecord::Migration
  def self.up
    add_column :collectives, :moderation_status, :string
  end

  def self.down
  end
end
