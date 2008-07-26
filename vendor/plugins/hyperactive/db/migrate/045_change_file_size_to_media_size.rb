class ChangeFileSizeToMediaSize < ActiveRecord::Migration
  def self.up
    rename_column :content, :file_size, :media_size
  end

  def self.down
    rename_column :content, :media_size, :file_size
  end
end
