class AddStickAtTopToContent < ActiveRecord::Migration
  def self.up
    add_column :content, :stick_at_top, :boolean
  end

  def self.down
    remove_column :content, :stick_at_top
  end
end
