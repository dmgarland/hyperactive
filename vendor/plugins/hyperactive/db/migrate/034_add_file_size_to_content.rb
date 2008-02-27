class AddFileSizeToContent < ActiveRecord::Migration
  def self.up
    add_column :content, :file_size, :integer
  end

  def self.down
    remove_column :content, :file_size
  end
end
