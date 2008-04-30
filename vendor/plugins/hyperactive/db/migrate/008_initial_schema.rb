class InitialSchema < ActiveRecord::Migration
  def self.up
  
    create_table "categories", :force => false do |t|
      t.column "name", :string, :default => "", :null => false
      t.column "description", :text, :default => "", :null => false
      t.column "active", :boolean, :default => false, :null => false
      t.column "created_on", :timestamp
      t.column "updated_on", :timestamp
    end
  
    create_table "categories_events", :id => false, :force => false do |t|
      t.column "category_id", :integer, :default => 0, :null => false
      t.column "event_id", :integer, :default => 0, :null => false
    end
  
    add_index "categories_events", ["category_id"], :name => "category_id"
    add_index "categories_events", ["event_id"], :name => "event_id"
  
    create_table "events", :force => false do |t|
      t.column "title", :string, :default => "", :null => false
      t.column "date", :datetime, :null => false
      t.column "description", :text, :default => "", :null => false
      t.column "place", :string, :default => "", :null => false
      t.column "published", :boolean, :default => true, :null => false
      t.column "hidden", :boolean, :default => false, :null => false
      t.column "created_on", :timestamp
      t.column "updated_on", :timestamp
      t.column "summary", :text, :default => "", :null => false
      t.column "source", :text
      t.column "published_by", :string, :default => "", :null => false
      t.column "promoted", :boolean, :default => false, :null => false
      t.column "end_date", :datetime
    end
  
    create_table "file_uploads", :force => false do |t|
      t.column "title", :string, :default => "", :null => false
      t.column "file", :string, :default => "", :null => false
      t.column "event_id", :integer, :default => 0, :null => false
      t.column "created_on", :timestamp
      t.column "updated_on", :timestamp
    end
  
    add_index "file_uploads", ["event_id"], :name => "fk_file_upload_event"
  
    create_table "links", :force => false do |t|
      t.column "title", :string, :default => "", :null => false
      t.column "url", :string, :default => "", :null => false
      t.column "description", :text
      t.column "created_on", :timestamp
      t.column "updated_on", :timestamp
      t.column "event_id", :integer, :default => 0, :null => false
    end
  
    add_index "links", ["event_id"], :name => "fk2_link_event"
  
    create_table "pages", :force => false do |t|
      t.column "title", :string, :default => "", :null => false
      t.column "body", :text, :default => "", :null => false
      t.column "created_on", :timestamp
      t.column "updated_on", :timestamp
    end
  
    create_table "photos", :force => false do |t|
      t.column "file", :string, :default => "", :null => false
      t.column "title", :string, :default => "", :null => false
      t.column "event_id", :integer, :default => 0, :null => false
    end
  
    add_index "photos", ["event_id"], :name => "fk2_photo_event"
  
  
  end

  def self.down
    drop_table :categories
    drop_table :categories_events
    drop_table :events
    drop_table :file_uploads
    drop_table :links
    drop_table :pages
    drop_table :photos
  end
end
