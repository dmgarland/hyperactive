class ChangeDescriptionToBody < ActiveRecord::Migration
  def self.up
    rename_column :events, :description, :body
  end

  def self.down
    rename_column :events, :body, :description
  end
end
