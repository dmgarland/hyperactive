class AddEventEventGroup < ActiveRecord::Migration
  def self.up
    add_column :events, :event_group_id, :integer
    add_index "events", ["event_group_id"], :name => "fk_event_event_group"
  end

  def self.down
    remove_column :events, :event_group
  end
end
