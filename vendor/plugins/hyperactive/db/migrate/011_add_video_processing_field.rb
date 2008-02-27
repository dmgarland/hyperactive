class AddVideoProcessingField < ActiveRecord::Migration
  def self.up
    add_column :videos, :processing_status, :integer
  end

  def self.down
    remove_column :videos, :processing_status
  end
end
