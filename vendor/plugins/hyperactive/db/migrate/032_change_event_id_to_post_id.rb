class ChangeEventIdToPostId < ActiveRecord::Migration
  def self.up
    rename_column :videos, :event_id, :content_id
    rename_column :photos, :event_id, :content_id
    rename_column :file_uploads, :event_id, :content_id
  end

  def self.down
    rename_column :videos, :content_id, :event_id
    rename_column :photos, :content_id, :event_id
    rename_column :file_uploads, :content_id, :event_id    
  end
end
