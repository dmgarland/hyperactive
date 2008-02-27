class MoveLinksToPostInsteadOfEvent < ActiveRecord::Migration
  def self.up
    rename_column :links, :event_id, :post_id
  end

  def self.down
    rename_column :links, :post_id, :event_id
  end
end
