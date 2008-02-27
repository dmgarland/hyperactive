class CreateVideos < ActiveRecord::Migration
  def self.up
    create_table "videos", :force => true do |t|
      t.column "title", :string, :default => "", :null => false
      t.column "file", :string, :default => "", :null => false
      t.column "event_id", :integer, :default => 0, :null => false
      t.column "created_on", :timestamp
      t.column "updated_on", :timestamp
    end
  
    add_index "videos", ["event_id"], :name => "fk_event_video"
  end

  def self.down
    drop_table :videos
  end
end
