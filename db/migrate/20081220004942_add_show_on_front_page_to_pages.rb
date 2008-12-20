class AddShowOnFrontPageToPages < ActiveRecord::Migration
  def self.up
    add_column :pages, :show_on_front, :boolean, :default => true, :null => false
  end

  def self.down
    remove_column :pages, :show_on_front
  end
end
