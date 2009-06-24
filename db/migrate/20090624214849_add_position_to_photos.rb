class AddPositionToPhotos < ActiveRecord::Migration
  def self.up
    add_column :photos, :position, :integer, :default => 0, :null => false
  end

  def self.down
    remove_column :photos, :position
  end
end

