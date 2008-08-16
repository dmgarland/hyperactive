class AddImageToCollective < ActiveRecord::Migration
  def self.up
    add_column :collectives, :image, :string
  end

  def self.down
    remove_column :collectives, :image
  end
end
