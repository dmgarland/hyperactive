# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20090805212542) do

  create_table "action_alerts", :force => true do |t|
    t.text     "summary",                          :null => false
    t.boolean  "on_front_page", :default => false, :null => false
    t.datetime "created_on"
    t.datetime "updated_on"
  end

  create_table "acts_as_xapian_jobs", :force => true do |t|
    t.string  "model",    :null => false
    t.integer "model_id", :null => false
    t.string  "action",   :null => false
  end

  add_index "acts_as_xapian_jobs", ["model", "model_id"], :name => "index_acts_as_xapian_jobs_on_model_and_model_id", :unique => true

  create_table "admin_filters", :force => true do |t|
    t.string   "title"
    t.text     "summary"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "categories", :force => true do |t|
    t.string   "name",        :default => "",    :null => false
    t.text     "description",                    :null => false
    t.boolean  "active",      :default => false, :null => false
    t.datetime "created_on"
    t.datetime "updated_on"
  end

  create_table "categories_events", :id => false, :force => true do |t|
    t.integer "category_id", :default => 0, :null => false
    t.integer "event_id",    :default => 0, :null => false
  end

  add_index "categories_events", ["category_id"], :name => "category_id"
  add_index "categories_events", ["event_id"], :name => "event_id"

  create_table "collective_associations", :force => true do |t|
    t.integer  "collective_associatable_id"
    t.string   "collective_associatable_type"
    t.integer  "collective_id"
    t.datetime "created_on"
    t.datetime "updated_on"
  end

  create_table "collective_memberships", :force => true do |t|
    t.integer  "collective_id"
    t.integer  "user_id"
    t.datetime "created_on"
    t.datetime "updated_on"
  end

  create_table "collectives", :force => true do |t|
    t.string   "name"
    t.text     "summary"
    t.string   "image"
    t.datetime "created_on"
    t.datetime "updated_on"
    t.string   "moderation_status"
  end

  create_table "comments", :force => true do |t|
    t.string   "title",                                           :null => false
    t.text     "body",                                            :null => false
    t.datetime "created_on"
    t.datetime "updated_on"
    t.string   "published_by",                    :default => "", :null => false
    t.string   "moderation_status", :limit => 50
    t.integer  "content_id",                                      :null => false
  end

  add_index "comments", ["content_id"], :name => "fk_comments_content"

  create_table "content", :force => true do |t|
    t.string   "title",                   :default => "",    :null => false
    t.datetime "date"
    t.text     "body"
    t.string   "place",                   :default => "",    :null => false
    t.datetime "created_on"
    t.datetime "updated_on"
    t.text     "summary",                                    :null => false
    t.string   "source"
    t.string   "published_by",            :default => "",    :null => false
    t.datetime "end_date"
    t.integer  "event_group_id"
    t.string   "contact_email"
    t.string   "contact_phone"
    t.integer  "user_id"
    t.string   "type",                                       :null => false
    t.string   "file"
    t.integer  "content_id"
    t.integer  "processing_status"
    t.integer  "media_size"
    t.string   "moderation_status"
    t.boolean  "allows_comments",         :default => true
    t.boolean  "stick_at_top"
    t.integer  "collective_id"
    t.boolean  "auto_moderation_checked", :default => false
    t.text     "admin_note",                                 :null => false
  end

  add_index "content", ["event_group_id"], :name => "fk_event_event_group"

  create_table "content_filter_expressions", :force => true do |t|
    t.string   "regexp"
    t.string   "summary"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "content_filter_id"
  end

  create_table "content_filters", :force => true do |t|
    t.string   "title"
    t.text     "summary"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "event_groups", :force => true do |t|
    t.datetime "created_on"
    t.datetime "updated_on"
  end

  create_table "external_feeds", :force => true do |t|
    t.string   "url"
    t.string   "title"
    t.string   "summary"
    t.integer  "collective_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "file_uploads", :force => true do |t|
    t.string   "title",      :default => "", :null => false
    t.string   "file",       :default => "", :null => false
    t.integer  "content_id"
    t.datetime "created_on"
    t.datetime "updated_on"
  end

  add_index "file_uploads", ["content_id"], :name => "fk_file_upload_event"

  create_table "groups", :force => true do |t|
    t.datetime "created_at",                                :null => false
    t.datetime "updated_at",                                :null => false
    t.string   "title",      :limit => 200, :default => "", :null => false
    t.integer  "parent_id"
  end

  add_index "groups", ["parent_id"], :name => "groups_parent_id_index"

  create_table "groups_roles", :id => false, :force => true do |t|
    t.integer  "group_id",   :default => 0, :null => false
    t.integer  "role_id",    :default => 0, :null => false
    t.datetime "created_at",                :null => false
  end

  add_index "groups_roles", ["group_id", "role_id"], :name => "groups_roles_all_index", :unique => true
  add_index "groups_roles", ["role_id"], :name => "role_id"

  create_table "groups_users", :id => false, :force => true do |t|
    t.integer  "group_id",   :default => 0, :null => false
    t.integer  "user_id",    :default => 0, :null => false
    t.datetime "created_at",                :null => false
  end

  add_index "groups_users", ["group_id", "user_id"], :name => "groups_users_all_index", :unique => true
  add_index "groups_users", ["user_id"], :name => "user_id"

  create_table "links", :force => true do |t|
    t.string   "title",       :default => "", :null => false
    t.string   "url",         :default => "", :null => false
    t.text     "description"
    t.datetime "created_on"
    t.datetime "updated_on"
    t.integer  "post_id"
  end

  add_index "links", ["post_id"], :name => "fk2_link_event"

  create_table "open_street_map_infos", :force => true do |t|
    t.float    "lat"
    t.float    "lng"
    t.integer  "zoom"
    t.integer  "content_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "pages", :force => true do |t|
    t.string   "title",         :default => "",   :null => false
    t.text     "body",                            :null => false
    t.datetime "created_on"
    t.datetime "updated_on"
    t.boolean  "show_on_front", :default => true, :null => false
  end

  create_table "photos", :force => true do |t|
    t.string   "file",       :default => "", :null => false
    t.string   "title",      :default => "", :null => false
    t.integer  "content_id"
    t.datetime "created_on"
    t.integer  "position",   :default => 0,  :null => false
  end

  add_index "photos", ["content_id"], :name => "fk2_photo_event"

  create_table "place_taggings", :force => true do |t|
    t.integer  "place_tag_id",                           :null => false
    t.integer  "place_taggable_id",                      :null => false
    t.string   "place_taggable_type",                    :null => false
    t.boolean  "hide_tag",            :default => false, :null => false
    t.datetime "event_date"
  end

  add_index "place_taggings", ["place_tag_id", "place_taggable_id", "place_taggable_type"], :name => "place_taggable_index", :unique => true

  create_table "place_tags", :force => true do |t|
    t.string "name", :null => false
  end

  add_index "place_tags", ["name"], :name => "index_place_tags_on_name", :unique => true

  create_table "playlist_items", :force => true do |t|
    t.string   "uri"
    t.integer  "collective_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "title",         :null => false
  end

  create_table "podcasts", :force => true do |t|
    t.string   "title"
    t.text     "summary"
    t.string   "file"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "quotes", :force => true do |t|
    t.text     "body"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "roles", :force => true do |t|
    t.datetime "created_at",                                :null => false
    t.datetime "updated_at",                                :null => false
    t.string   "title",      :limit => 100, :default => "", :null => false
    t.integer  "parent_id"
  end

  add_index "roles", ["parent_id"], :name => "roles_parent_id_index"

  create_table "roles_static_permissions", :id => false, :force => true do |t|
    t.integer  "role_id",              :default => 0, :null => false
    t.integer  "static_permission_id", :default => 0, :null => false
    t.datetime "created_at",                          :null => false
  end

  add_index "roles_static_permissions", ["role_id"], :name => "role_id"
  add_index "roles_static_permissions", ["static_permission_id", "role_id"], :name => "roles_static_permissions_all_index", :unique => true

  create_table "roles_users", :id => false, :force => true do |t|
    t.integer  "user_id",    :default => 0, :null => false
    t.integer  "role_id",    :default => 0, :null => false
    t.datetime "created_at",                :null => false
  end

  add_index "roles_users", ["role_id"], :name => "role_id"
  add_index "roles_users", ["user_id", "role_id"], :name => "roles_users_all_index", :unique => true

  create_table "sessions", :force => true do |t|
    t.string   "session_id", :null => false
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"
  add_index "sessions", ["updated_at"], :name => "index_sessions_on_updated_at"

  create_table "settings", :force => true do |t|
    t.string   "key"
    t.string   "string_value"
    t.integer  "integer_value"
    t.boolean  "boolean_value"
    t.string   "type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "slugs", :force => true do |t|
    t.string   "name"
    t.string   "sluggable_type"
    t.integer  "sluggable_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "slugs", ["name", "sluggable_type"], :name => "index_slugs_on_name_and_sluggable_type", :unique => true
  add_index "slugs", ["sluggable_id"], :name => "index_slugs_on_sluggable_id"

  create_table "snippets", :force => true do |t|
    t.string   "title"
    t.text     "body"
    t.datetime "created_on"
    t.datetime "updated_on"
    t.string   "key"
    t.string   "url"
    t.string   "image"
  end

  create_table "static_permissions", :force => true do |t|
    t.string   "title",      :limit => 200, :default => "", :null => false
    t.datetime "created_at",                                :null => false
    t.datetime "updated_at",                                :null => false
  end

  add_index "static_permissions", ["title"], :name => "static_permissions_title_index", :unique => true

  create_table "taggings", :force => true do |t|
    t.integer  "tag_id",                           :null => false
    t.integer  "taggable_id",                      :null => false
    t.string   "taggable_type",                    :null => false
    t.boolean  "hide_tag",      :default => false, :null => false
    t.datetime "event_date"
  end

  add_index "taggings", ["tag_id", "taggable_id", "taggable_type"], :name => "index_taggings_on_tag_id_and_taggable_id_and_taggable_type", :unique => true

  create_table "tags", :force => true do |t|
    t.string "name", :null => false
  end

  add_index "tags", ["name"], :name => "index_tags_on_name", :unique => true

  create_table "user_registrations", :force => true do |t|
    t.integer  "user_id",    :default => 0, :null => false
    t.text     "token",                     :null => false
    t.datetime "created_at",                :null => false
    t.datetime "expires_at",                :null => false
  end

  add_index "user_registrations", ["expires_at"], :name => "user_registrations_expires_at_index"
  add_index "user_registrations", ["user_id"], :name => "user_registrations_user_id_index", :unique => true

  create_table "users", :force => true do |t|
    t.datetime "created_at",                                                   :null => false
    t.datetime "updated_at",                                                   :null => false
    t.datetime "last_logged_in_at",                                            :null => false
    t.integer  "login_failure_count",                :default => 0,            :null => false
    t.string   "login",               :limit => 100, :default => "",           :null => false
    t.string   "email",               :limit => 200, :default => "",           :null => false
    t.string   "password",            :limit => 100, :default => "",           :null => false
    t.string   "password_hash_type",  :limit => 20,  :default => "",           :null => false
    t.string   "password_salt",       :limit => 10,  :default => "1234512345", :null => false
    t.integer  "state",                              :default => 1,            :null => false
  end

  add_index "users", ["login"], :name => "users_login_index", :unique => true
  add_index "users", ["password"], :name => "users_password_index"

  create_table "versions", :force => true do |t|
    t.integer  "versionable_id"
    t.string   "versionable_type"
    t.integer  "number"
    t.text     "yaml"
    t.datetime "created_at"
  end

  add_index "versions", ["versionable_id", "versionable_type"], :name => "index_versions_on_versionable_id_and_versionable_type"

  create_table "videos", :force => true do |t|
    t.string   "title",             :default => "", :null => false
    t.string   "file",              :default => "", :null => false
    t.integer  "content_id"
    t.datetime "created_on"
    t.datetime "updated_on"
    t.string   "body"
    t.integer  "processing_status"
  end

  add_index "videos", ["content_id"], :name => "fk_event_video"

end
