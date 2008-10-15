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

ActiveRecord::Schema.define(:version => 20081015204841) do

  create_table "action_alerts", :force => true do |t|
    t.string   "summary",                          :null => false
    t.boolean  "on_front_page", :default => false, :null => false
    t.datetime "created_on"
    t.datetime "updated_on"
  end

  create_table "categories", :force => true do |t|
    t.string   "name",        :default => "",    :null => false
    t.text     "description",                    :null => false
    t.boolean  "active",      :default => false, :null => false
    t.datetime "created_on"
    t.datetime "updated_on"
  end

  create_table "categories_events", :id => false, :force => true do |t|
    t.integer "category_id", :limit => 11, :default => 0, :null => false
    t.integer "event_id",    :limit => 11, :default => 0, :null => false
  end

  add_index "categories_events", ["category_id"], :name => "category_id"
  add_index "categories_events", ["event_id"], :name => "event_id"

  create_table "collective_associations", :force => true do |t|
    t.integer  "collective_associatable_id",   :limit => 11
    t.string   "collective_associatable_type"
    t.integer  "collective_id",                :limit => 11
    t.datetime "created_on"
    t.datetime "updated_on"
  end

  create_table "collective_memberships", :force => true do |t|
    t.integer  "collective_id", :limit => 11
    t.integer  "user_id",       :limit => 11
    t.datetime "created_on"
    t.datetime "updated_on"
  end

  create_table "collectives", :force => true do |t|
    t.string   "name"
    t.text     "summary"
    t.string   "image"
    t.datetime "created_on"
    t.datetime "updated_on"
  end

  create_table "comments", :force => true do |t|
    t.string   "title",                                           :null => false
    t.text     "body",                                            :null => false
    t.datetime "created_on"
    t.datetime "updated_on"
    t.string   "published_by",                    :default => "", :null => false
    t.string   "moderation_status", :limit => 50
    t.integer  "content_id",        :limit => 11,                 :null => false
  end

  add_index "comments", ["content_id"], :name => "fk_comments_content"

  create_table "content", :force => true do |t|
    t.string   "title",                           :default => "",   :null => false
    t.datetime "date"
    t.text     "body"
    t.string   "place",                           :default => "",   :null => false
    t.datetime "created_on"
    t.datetime "updated_on"
    t.text     "summary",                                           :null => false
    t.text     "source"
    t.string   "published_by",                    :default => "",   :null => false
    t.datetime "end_date"
    t.integer  "event_group_id",    :limit => 11
    t.string   "contact_email"
    t.string   "contact_phone"
    t.integer  "user_id",           :limit => 11
    t.string   "type",                                              :null => false
    t.string   "file"
    t.integer  "content_id",        :limit => 11
    t.integer  "processing_status", :limit => 11
    t.integer  "media_size",        :limit => 11
    t.string   "moderation_status"
    t.boolean  "allows_comments",                 :default => true
    t.boolean  "stick_at_top"
  end

  add_index "content", ["event_group_id"], :name => "fk_event_event_group"

  create_table "event_groups", :force => true do |t|
    t.datetime "created_on"
    t.datetime "updated_on"
  end

  create_table "file_uploads", :force => true do |t|
    t.string   "title",                    :default => "", :null => false
    t.string   "file",                     :default => "", :null => false
    t.integer  "content_id", :limit => 11
    t.datetime "created_on"
    t.datetime "updated_on"
  end

  add_index "file_uploads", ["content_id"], :name => "fk_file_upload_event"

  create_table "globalize_countries", :force => true do |t|
    t.string "code",                   :limit => 2
    t.string "english_name"
    t.string "date_format"
    t.string "currency_format"
    t.string "currency_code",          :limit => 3
    t.string "thousands_sep",          :limit => 2
    t.string "decimal_sep",            :limit => 2
    t.string "currency_decimal_sep",   :limit => 2
    t.string "number_grouping_scheme"
  end

  add_index "globalize_countries", ["code"], :name => "index_globalize_countries_on_code"

  create_table "globalize_languages", :force => true do |t|
    t.string  "iso_639_1",             :limit => 2
    t.string  "iso_639_2",             :limit => 3
    t.string  "iso_639_3",             :limit => 3
    t.string  "rfc_3066"
    t.string  "english_name"
    t.string  "english_name_locale"
    t.string  "english_name_modifier"
    t.string  "native_name"
    t.string  "native_name_locale"
    t.string  "native_name_modifier"
    t.boolean "macro_language"
    t.string  "direction"
    t.string  "pluralization"
    t.string  "scope",                 :limit => 1
  end

  add_index "globalize_languages", ["iso_639_1"], :name => "index_globalize_languages_on_iso_639_1"
  add_index "globalize_languages", ["iso_639_2"], :name => "index_globalize_languages_on_iso_639_2"
  add_index "globalize_languages", ["iso_639_3"], :name => "index_globalize_languages_on_iso_639_3"
  add_index "globalize_languages", ["rfc_3066"], :name => "index_globalize_languages_on_rfc_3066"

  create_table "globalize_translations", :force => true do |t|
    t.string  "type"
    t.string  "tr_key"
    t.string  "table_name"
    t.integer "item_id",             :limit => 11
    t.string  "facet"
    t.boolean "built_in",                          :default => true
    t.integer "language_id",         :limit => 11
    t.integer "pluralization_index", :limit => 11
    t.text    "text"
    t.string  "namespace"
  end

  add_index "globalize_translations", ["tr_key", "language_id"], :name => "index_globalize_translations_on_tr_key_and_language_id"
  add_index "globalize_translations", ["table_name", "item_id", "language_id"], :name => "globalize_translations_table_name_and_item_and_language"

  create_table "groups", :force => true do |t|
    t.timestamp "created_at",                                :null => false
    t.timestamp "updated_at",                                :null => false
    t.string    "title",      :limit => 200, :default => "", :null => false
    t.integer   "parent_id",  :limit => 10
  end

  add_index "groups", ["parent_id"], :name => "groups_parent_id_index"

  create_table "groups_roles", :id => false, :force => true do |t|
    t.integer   "group_id",   :limit => 10, :default => 0, :null => false
    t.integer   "role_id",    :limit => 10, :default => 0, :null => false
    t.timestamp "created_at",                              :null => false
  end

  add_index "groups_roles", ["group_id", "role_id"], :name => "groups_roles_all_index", :unique => true
  add_index "groups_roles", ["role_id"], :name => "role_id"

  create_table "groups_users", :id => false, :force => true do |t|
    t.integer   "group_id",   :limit => 10, :default => 0, :null => false
    t.integer   "user_id",    :limit => 10, :default => 0, :null => false
    t.timestamp "created_at",                              :null => false
  end

  add_index "groups_users", ["group_id", "user_id"], :name => "groups_users_all_index", :unique => true
  add_index "groups_users", ["user_id"], :name => "user_id"

  create_table "links", :force => true do |t|
    t.string   "title",                     :default => "", :null => false
    t.string   "url",                       :default => "", :null => false
    t.text     "description"
    t.datetime "created_on"
    t.datetime "updated_on"
    t.integer  "post_id",     :limit => 11
  end

  add_index "links", ["post_id"], :name => "fk2_link_event"

  create_table "pages", :force => true do |t|
    t.string   "title",      :default => "", :null => false
    t.text     "body",                       :null => false
    t.datetime "created_on"
    t.datetime "updated_on"
  end

  create_table "photos", :force => true do |t|
    t.string   "file",                     :default => "", :null => false
    t.string   "title",                    :default => "", :null => false
    t.integer  "content_id", :limit => 11
    t.datetime "created_on"
  end

  add_index "photos", ["content_id"], :name => "fk2_photo_event"

  create_table "place_taggings", :force => true do |t|
    t.integer  "place_tag_id",        :limit => 11,                    :null => false
    t.integer  "place_taggable_id",   :limit => 11,                    :null => false
    t.string   "place_taggable_type",                                  :null => false
    t.boolean  "hide_tag",                          :default => false, :null => false
    t.datetime "event_date"
  end

  add_index "place_taggings", ["place_tag_id", "place_taggable_id", "place_taggable_type"], :name => "place_taggable_index", :unique => true

  create_table "place_tags", :force => true do |t|
    t.string "name", :null => false
  end

  add_index "place_tags", ["name"], :name => "index_place_tags_on_name", :unique => true

  create_table "plugin_schema_info", :id => false, :force => true do |t|
    t.string  "plugin_name"
    t.integer "version",     :limit => 11
  end

  create_table "roles", :force => true do |t|
    t.timestamp "created_at",                                :null => false
    t.timestamp "updated_at",                                :null => false
    t.string    "title",      :limit => 100, :default => "", :null => false
    t.integer   "parent_id",  :limit => 10
  end

  add_index "roles", ["parent_id"], :name => "roles_parent_id_index"

  create_table "roles_static_permissions", :id => false, :force => true do |t|
    t.integer   "role_id",              :limit => 10, :default => 0, :null => false
    t.integer   "static_permission_id", :limit => 10, :default => 0, :null => false
    t.timestamp "created_at",                                        :null => false
  end

  add_index "roles_static_permissions", ["static_permission_id", "role_id"], :name => "roles_static_permissions_all_index", :unique => true
  add_index "roles_static_permissions", ["role_id"], :name => "role_id"

  create_table "roles_users", :id => false, :force => true do |t|
    t.integer   "user_id",    :limit => 10, :default => 0, :null => false
    t.integer   "role_id",    :limit => 10, :default => 0, :null => false
    t.timestamp "created_at",                              :null => false
  end

  add_index "roles_users", ["user_id", "role_id"], :name => "roles_users_all_index", :unique => true
  add_index "roles_users", ["role_id"], :name => "role_id"

  create_table "sessions", :force => true do |t|
    t.string   "session_id", :null => false
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"
  add_index "sessions", ["updated_at"], :name => "index_sessions_on_updated_at"

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
    t.string    "title",      :limit => 200, :default => "", :null => false
    t.timestamp "created_at",                                :null => false
    t.timestamp "updated_at",                                :null => false
  end

  add_index "static_permissions", ["title"], :name => "static_permissions_title_index", :unique => true

  create_table "taggings", :force => true do |t|
    t.integer  "tag_id",        :limit => 11,                    :null => false
    t.integer  "taggable_id",   :limit => 11,                    :null => false
    t.string   "taggable_type",                                  :null => false
    t.boolean  "hide_tag",                    :default => false, :null => false
    t.datetime "event_date"
  end

  add_index "taggings", ["tag_id", "taggable_id", "taggable_type"], :name => "index_taggings_on_tag_id_and_taggable_id_and_taggable_type", :unique => true

  create_table "tags", :force => true do |t|
    t.string "name", :null => false
  end

  add_index "tags", ["name"], :name => "index_tags_on_name", :unique => true

  create_table "user_registrations", :force => true do |t|
    t.integer   "user_id",    :limit => 10, :default => 0, :null => false
    t.text      "token",                                   :null => false
    t.timestamp "created_at",                              :null => false
    t.timestamp "expires_at",                              :null => false
  end

  add_index "user_registrations", ["user_id"], :name => "user_registrations_user_id_index", :unique => true
  add_index "user_registrations", ["expires_at"], :name => "user_registrations_expires_at_index"

  create_table "users", :force => true do |t|
    t.timestamp "created_at",                                                   :null => false
    t.timestamp "updated_at",                                                   :null => false
    t.timestamp "last_logged_in_at",                                            :null => false
    t.integer   "login_failure_count", :limit => 10,  :default => 0,            :null => false
    t.string    "login",               :limit => 100, :default => "",           :null => false
    t.string    "email",               :limit => 200, :default => "",           :null => false
    t.string    "password",            :limit => 100, :default => "",           :null => false
    t.string    "password_hash_type",  :limit => 20,  :default => "",           :null => false
    t.string    "password_salt",       :limit => 10,  :default => "1234512345", :null => false
    t.integer   "state",               :limit => 10,  :default => 1,            :null => false
  end

  add_index "users", ["login"], :name => "users_login_index", :unique => true
  add_index "users", ["password"], :name => "users_password_index"

  create_table "versions", :force => true do |t|
    t.integer  "versionable_id",   :limit => 11
    t.string   "versionable_type"
    t.integer  "number",           :limit => 11
    t.text     "yaml"
    t.datetime "created_at"
  end

  add_index "versions", ["versionable_id", "versionable_type"], :name => "index_versions_on_versionable_id_and_versionable_type"

  create_table "videos", :force => true do |t|
    t.string   "title",                           :default => "", :null => false
    t.string   "file",                            :default => "", :null => false
    t.integer  "content_id",        :limit => 11
    t.datetime "created_on"
    t.datetime "updated_on"
    t.string   "body"
    t.integer  "processing_status", :limit => 11
  end

  add_index "videos", ["content_id"], :name => "fk_event_video"

end
