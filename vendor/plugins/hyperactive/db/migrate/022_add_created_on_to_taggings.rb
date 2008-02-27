class AddCreatedOnToTaggings < ActiveRecord::Migration
  def self.up
    add_column :taggings, :created_on, :datetime
    add_column :place_taggings, :created_on, :datetime
  end

  def self.down
    remove_column :taggings, :created_on
    remove_column :place_taggings, :created_on
  end
end
