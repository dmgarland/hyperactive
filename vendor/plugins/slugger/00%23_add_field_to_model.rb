class AddFieldToModel < ActiveRecord::Migration
  def self.up
    add_column :models, :field, :string
    add_index :models, :field
  end

  def self.down
    remove_column :models, :field
  end
end
