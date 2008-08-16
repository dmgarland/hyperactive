class AddImageToCollective < ActiveRecord::Migration
  def self.up
    add_column :collectives, :image, :string
    add_column :collectives, :created_on, :timestamp
    add_column :collectives, :updated_on, :timestamp
  end

  def self.down
    remove_column :collectives, :image
    remove_column :collectives, :created_on
    remove_column :collectives, :updated_on
  end
end
