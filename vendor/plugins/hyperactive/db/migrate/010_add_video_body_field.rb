class AddVideoBodyField < ActiveRecord::Migration
  def self.up
    add_column :videos, :body, :string
  end

  def self.down
    remove_column :videos, :body
  end
end
