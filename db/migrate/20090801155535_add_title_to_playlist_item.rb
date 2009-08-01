class AddTitleToPlaylistItem < ActiveRecord::Migration
  def self.up
    add_column :playlist_items, :title, :string, :null => false
  end

  def self.down
    remove_column :playlist_items, :title
  end
end

