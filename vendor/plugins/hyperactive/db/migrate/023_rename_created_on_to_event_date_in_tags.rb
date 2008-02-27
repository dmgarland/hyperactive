class RenameCreatedOnToEventDateInTags < ActiveRecord::Migration
  def self.up
    rename_column :taggings, :created_on, :event_date
    rename_column :place_taggings, :created_on, :event_date
  end

  def self.down
    rename_column :taggings, :event_date, :created_on
    rename_column :place_taggings, :event_date, :created_on
  end
end
