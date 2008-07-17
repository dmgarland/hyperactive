class AddCreatedOnToPhotos < ActiveRecord::Migration
  def self.up
    add_column :photos, :created_on, :datetime
  end

  def self.down
    remove_column :photos, :created_on
  end
end
