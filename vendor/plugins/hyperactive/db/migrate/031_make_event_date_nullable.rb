class MakeEventDateNullable < ActiveRecord::Migration
  def self.up
    change_column :content, :date, :datetime, :null => true, :default => nil
  end

  def self.down
  end
end
