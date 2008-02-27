class AddHiddenToTaggings < ActiveRecord::Migration
  def self.up
    add_column :taggings, :hide_tag, :boolean, :null => false, :default => false
    add_column :place_taggings, :hide_tag, :boolean, :null => false, :default => false
  end

  def self.down
    remove_column :taggings, :hide_tag
    remove_column :place_taggings, :hide_tag
  end
end
