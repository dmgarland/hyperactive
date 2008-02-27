class AddTypeColumnToContent < ActiveRecord::Migration
  def self.up
    add_column :content, :type, :string, :null => false
  end

  def self.down
    remove_column :content, :type
  end
end
