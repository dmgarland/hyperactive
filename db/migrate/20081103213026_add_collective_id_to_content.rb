class AddCollectiveIdToContent < ActiveRecord::Migration
  def self.up
    add_column :content, :collective_id, :integer, :default => nil
  end

  def self.down
    remove_column :content, :collective_id
  end
end
