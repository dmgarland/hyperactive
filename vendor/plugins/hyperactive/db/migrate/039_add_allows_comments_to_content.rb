class AddAllowsCommentsToContent < ActiveRecord::Migration
  
  def self.up
    add_column :content, :allows_comments, :boolean, :default => true
  end

  def self.down
    remove_column :content, :allows_comments
  end
  
end