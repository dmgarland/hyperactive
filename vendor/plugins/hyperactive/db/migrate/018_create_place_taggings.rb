class CreatePlaceTaggings < ActiveRecord::Migration
  def self.up
    create_table :place_taggings do |t|
      t.column :place_tag_id, :integer, :null => false
      t.column :place_taggable_id, :integer, :null => false
      t.column :place_taggable_type, :string, :null => false
    end
    add_index :place_taggings, [:place_tag_id, :place_taggable_id, :place_taggable_type], :unique => true, :name => "place_taggable_index"
  end

  def self.down
    drop_table :place_taggings
  end
end
