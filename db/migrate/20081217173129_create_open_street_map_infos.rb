class CreateOpenStreetMapInfos < ActiveRecord::Migration
  def self.up
    create_table :open_street_map_infos do |t|
      t.float :lat
      t.float :lng
      t.integer :zoom
      t.integer :content_id

      t.timestamps
    end
  end

  def self.down
    drop_table :open_street_map_infos
  end
end
