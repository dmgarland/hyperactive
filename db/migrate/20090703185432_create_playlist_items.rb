class CreatePlaylistItems < ActiveRecord::Migration
  def self.up
    create_table :playlist_items do |t|
      t.string :uri
      t.integer :collective_id

      t.timestamps
    end
  end

  def self.down
    drop_table :playlist_items
  end
end

