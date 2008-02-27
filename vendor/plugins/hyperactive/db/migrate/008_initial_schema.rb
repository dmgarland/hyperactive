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
  
    create_table "groups", :force => false do |t|
      t.column "created_at", :timestamp
      t.column "updated_at", :timestamp
      t.column "title", :string, :limit => 200, :default => "", :null => false
      t.column "parent_id", :integer, :limit => 10
    end
  
    add_index "groups", ["parent_id"], :name => "groups_parent_id_index"
  
    create_table "groups_roles", :id => false, :force => false do |t|
      t.column "group_id", :integer, :limit => 10, :default => 0, :null => false
      t.column "role_id", :integer, :limit => 10, :default => 0, :null => false
      t.column "created_at", :timestamp
    end
  
    add_index "groups_roles", ["group_id", "role_id"], :name => "groups_roles_all_index", :unique => true
    add_index "groups_roles", ["role_id"], :name => "role_id"
  
    create_table "groups_users", :id => false, :force => false do |t|
      t.column "group_id", :integer, :limit => 10, :default => 0, :null => false
      t.column "user_id", :integer, :limit => 10, :default => 0, :null => false
      t.column "created_at", :timestamp
    end
  
    add_index "groups_users", ["group_id", "user_id"], :name => "groups_users_all_index", :unique => true
    add_index "groups_users", ["user_id"], :name => "user_id"
  
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
  
    create_table "roles", :force => false do |t|
      t.column "created_at", :timestamp
      t.column "updated_at", :timestamp
      t.column "title", :string, :limit => 100, :default => "", :null => false
      t.column "parent_id", :integer, :limit => 10
    end
  
    add_index "roles", ["parent_id"], :name => "roles_parent_id_index"
  
    create_table "roles_static_permissions", :id => false, :force => false do |t|
      t.column "role_id", :integer, :limit => 10, :default => 0, :null => false
      t.column "static_permission_id", :integer, :limit => 10, :default => 0, :null => false
      t.column "created_at", :timestamp
    end
  
    add_index "roles_static_permissions", ["static_permission_id", "role_id"], :name => "roles_static_permissions_all_index", :unique => true
  
    create_table "roles_users", :id => false, :force => false do |t|
      t.column "user_id", :integer, :limit => 10, :default => 0, :null => false
      t.column "role_id", :integer, :limit => 10, :default => 0, :null => false
      t.column "created_at", :timestamp
    end
  
    add_index "roles_users", ["user_id", "role_id"], :name => "roles_users_all_index", :unique => true
  
    create_table "static_permissions", :force => false do |t|
      t.column "title", :string, :limit => 200, :default => "", :null => false
      t.column "created_at", :timestamp
      t.column "updated_at", :timestamp
    end
  
    add_index "static_permissions", ["title"], :name => "static_permissions_title_index", :unique => true
   
    create_table "user_registrations", :force => false do |t|
      t.column "user_id", :integer, :limit => 10, :default => 0, :null => false
      t.column "token", :text, :default => "", :null => false
      t.column "created_at", :timestamp
      t.column "expires_at", :timestamp
    end
  
    add_index "user_registrations", ["user_id"], :name => "user_registrations_user_id_index", :unique => true
    add_index "user_registrations", ["expires_at"], :name => "user_registrations_expires_at_index"
  
    create_table "users", :force => false do |t|
      t.column "created_at", :timestamp
      t.column "updated_at", :timestamp
      t.column "last_logged_in_at", :timestamp
      t.column "login_failure_count", :integer, :limit => 10, :default => 0, :null => false
      t.column "login", :string, :limit => 100, :default => "", :null => false
      t.column "email", :string, :limit => 200, :default => "", :null => false
      t.column "password", :string, :limit => 100, :default => "", :null => false
      t.column "password_hash_type", :string, :limit => 20, :default => "", :null => false
      t.column "password_salt", :string, :limit => 10, :default => "1234512345", :null => false
      t.column "state", :integer, :limit => 10, :default => 1, :null => false
    end
  
    add_index "users", ["login"], :name => "users_login_index", :unique => true
    add_index "users", ["password"], :name => "users_password_index"
  
  end

  def self.down
    drop_table :categories
    drop_table :categories_events
    drop_table :events
    drop_table :file_uploads
    drop_table :groups
    drop_table :groups_roles
    drop_table :groups_users
    drop_table :links
    drop_table :pages
    drop_table :photos
    drop_table :roles
    drop_table :roles_static_permissions
    drop_table :roles_users
    drop_table :static_permissions
    drop_table :user_registrations
    drop_table :users
  end
end
