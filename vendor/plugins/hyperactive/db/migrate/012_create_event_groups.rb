class CreateEventGroups < ActiveRecord::Migration
  def self.up
    create_table :event_groups do |t|
      t.column "created_on", :timestamp
      t.column "updated_on", :timestamp
    end
  end

  def self.down
    drop_table :event_groups
  end
end
