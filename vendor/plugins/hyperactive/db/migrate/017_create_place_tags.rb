class CreatePlaceTags < ActiveRecord::Migration
  def self.up
    create_table :place_tags do |t|
      t.column :name, :string, :null => false
    end
    add_index :place_tags, :name, :unique => true
  end

  def self.down
    drop_table :place_tags
  end
end
