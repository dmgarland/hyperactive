class RenameEventsToContent < ActiveRecord::Migration
  def self.up
    rename_table :events, :content
  end

  def self.down
    rename_table :content, :events
  end
end
