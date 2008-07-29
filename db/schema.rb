# This file is autogenerated. Instead of editing this file, please use the
# migrations feature of ActiveRecord to incrementally modify your database, and
# then regenerate this schema definition.

ActiveRecord::Schema.define(:version => 19) do

  create_table "action_alerts", :force => true do |t|
    t.column "summary",       :string,   :default => "",    :null => false
    t.column "on_front_page", :boolean,  :default => false, :null => false
    t.column "created_on",    :datetime
    t.column "updated_on",    :datetime
  end

  create_table "categories", :force => true do |t|
    t.column "name",        :string,   :default => "",    :null => false
    t.column "description", :text,     :default => "",    :null => false
    t.column "active",      :boolean,  :default => false, :null => false
    t.column "created_on",  :datetime
    t.column "updated_on",  :datetime
  end

  create_table "categories_events", :id => false, :force => true do |t|
    t.column "category_id", :integer, :default => 0, :null => false
    t.column "event_id",    :integer, :default => 0, :null => false
  end

  add_index "categories_events", ["category_id"], :name => "category_id"
  add_index "categories_events", ["event_id"], :name => "event_id"

  create_table "comments", :force => true do |t|
    t.column "title",             :string,                 :default => "", :null => false
    t.column "body",              :text,                   :default => "", :null => false
    t.column "created_on",        :datetime
    t.column "updated_on",        :datetime
    t.column "published_by",      :string,                 :default => "", :null => false
    t.column "moderation_status", :string,   :limit => 50
    t.column "content_id",        :integer,                                :null => false
  end

  add_index "comments", ["content_id"], :name => "fk_comments_content"

  create_table "content", :force => true do |t|
    t.column "title",             :string,   :default => "",   :null => false
    t.column "date",              :datetime
    t.column "body",              :text
    t.column "place",             :string,   :default => "",   :null => false
    t.column "created_on",        :datetime
    t.column "updated_on",        :datetime
    t.column "summary",           :text,     :default => "",   :null => false
    t.column "source",            :text
    t.column "published_by",      :string,   :default => "",   :null => false
    t.column "end_date",          :datetime
    t.column "event_group_id",    :integer
    t.column "contact_email",     :string
    t.column "contact_phone",     :string
    t.column "user_id",           :integer
    t.column "type",              :string,   :default => "",   :null => false
    t.column "file",              :string
    t.column "content_id",        :integer
    t.column "processing_status", :integer
    t.column "media_size",        :integer
    t.column "moderation_status", :string
    t.column "allows_comments",   :boolean,  :default => true
    t.column "stick_at_top",      :boolean
  end

  add_index "content", ["event_group_id"], :name => "fk_event_event_group"

  create_table "event_groups", :force => true do |t|
    t.column "created_on", :datetime
    t.column "updated_on", :datetime
  end

  create_table "file_uploads", :force => true do |t|
    t.column "title",      :string,   :default => "", :null => false
    t.column "file",       :string,   :default => "", :null => false
    t.column "content_id", :integer
    t.column "created_on", :datetime
    t.column "updated_on", :datetime
  end

  add_index "file_uploads", ["content_id"], :name => "fk_file_upload_event"

  create_table "globalize_countries", :force => true do |t|
    t.column "code",                   :string, :limit => 2
    t.column "english_name",           :string
    t.column "date_format",            :string
    t.column "currency_format",        :string
    t.column "currency_code",          :string, :limit => 3
    t.column "thousands_sep",          :string, :limit => 2
    t.column "decimal_sep",            :string, :limit => 2
    t.column "currency_decimal_sep",   :string, :limit => 2
    t.column "number_grouping_scheme", :string
  end

  add_index "globalize_countries", ["code"], :name => "index_globalize_countries_on_code"

  create_table "globalize_languages", :force => true do |t|
    t.column "iso_639_1",             :string,  :limit => 2
    t.column "iso_639_2",             :string,  :limit => 3
    t.column "iso_639_3",             :string,  :limit => 3
    t.column "rfc_3066",              :string
    t.column "english_name",          :string
    t.column "english_name_locale",   :string
    t.column "english_name_modifier", :string
    t.column "native_name",           :string
    t.column "native_name_locale",    :string
    t.column "native_name_modifier",  :string
    t.column "macro_language",        :boolean
    t.column "direction",             :string
    t.column "pluralization",         :string
    t.column "scope",                 :string,  :limit => 1
  end

  add_index "globalize_languages", ["iso_639_1"], :name => "index_globalize_languages_on_iso_639_1"
  add_index "globalize_languages", ["iso_639_2"], :name => "index_globalize_languages_on_iso_639_2"
  add_index "globalize_languages", ["iso_639_3"], :name => "index_globalize_languages_on_iso_639_3"
  add_index "globalize_languages", ["rfc_3066"], :name => "index_globalize_languages_on_rfc_3066"

  create_table "globalize_translations", :force => true do |t|
    t.column "type",                :string
    t.column "tr_key",              :string
    t.column "table_name",          :string
    t.column "item_id",             :integer
    t.column "facet",               :string
    t.column "built_in",            :boolean, :default => true
    t.column "language_id",         :integer
    t.column "pluralization_index", :integer
    t.column "text",                :text
    t.column "namespace",           :string
  end

  add_index "globalize_translations", ["tr_key", "language_id"], :name => "index_globalize_translations_on_tr_key_and_language_id"
  add_index "globalize_translations", ["table_name", "item_id", "language_id"], :name => "globalize_translations_table_name_and_item_and_language"

  create_table "groups", :force => true do |t|
    t.column "created_at", :timestamp,                                :null => false
    t.column "updated_at", :timestamp,                                :null => false
    t.column "title",      :string,    :limit => 200, :default => "", :null => false
    t.column "parent_id",  :integer,   :limit => 10
  end

  add_index "groups", ["parent_id"], :name => "groups_parent_id_index"

  create_table "groups_roles", :id => false, :force => true do |t|
    t.column "group_id",   :integer,   :limit => 10, :default => 0, :null => false
    t.column "role_id",    :integer,   :limit => 10, :default => 0, :null => false
    t.column "created_at", :timestamp,                              :null => false
  end

  add_index "groups_roles", ["group_id", "role_id"], :name => "groups_roles_all_index", :unique => true
  add_index "groups_roles", ["role_id"], :name => "role_id"

  create_table "groups_users", :id => false, :force => true do |t|
    t.column "group_id",   :integer,   :limit => 10, :default => 0, :null => false
    t.column "user_id",    :integer,   :limit => 10, :default => 0, :null => false
    t.column "created_at", :timestamp,                              :null => false
  end

  add_index "groups_users", ["group_id", "user_id"], :name => "groups_users_all_index", :unique => true
  add_index "groups_users", ["user_id"], :name => "user_id"

  create_table "links", :force => true do |t|
    t.column "title",       :string,   :default => "", :null => false
    t.column "url",         :string,   :default => "", :null => false
    t.column "description", :text
    t.column "created_on",  :datetime
    t.column "updated_on",  :datetime
    t.column "post_id",     :integer
  end

  add_index "links", ["post_id"], :name => "fk2_link_event"

  create_table "pages", :force => true do |t|
    t.column "title",      :string,   :default => "", :null => false
    t.column "body",       :text,     :default => "", :null => false
    t.column "created_on", :datetime
    t.column "updated_on", :datetime
  end

  create_table "photos", :force => true do |t|
    t.column "file",       :string,   :default => "", :null => false
    t.column "title",      :string,   :default => "", :null => false
    t.column "content_id", :integer
    t.column "created_on", :datetime
  end

  add_index "photos", ["content_id"], :name => "fk2_photo_event"

  create_table "place_taggings", :force => true do |t|
    t.column "place_tag_id",        :integer,                     :null => false
    t.column "place_taggable_id",   :integer,                     :null => false
    t.column "place_taggable_type", :string,   :default => "",    :null => false
    t.column "hide_tag",            :boolean,  :default => false, :null => false
    t.column "event_date",          :datetime
  end

  add_index "place_taggings", ["place_tag_id", "place_taggable_id", "place_taggable_type"], :name => "place_taggable_index", :unique => true

  create_table "place_tags", :force => true do |t|
    t.column "name", :string, :default => "", :null => false
  end

  add_index "place_tags", ["name"], :name => "index_place_tags_on_name", :unique => true

  create_table "roles", :force => true do |t|
    t.column "created_at", :timestamp,                                :null => false
    t.column "updated_at", :timestamp,                                :null => false
    t.column "title",      :string,    :limit => 100, :default => "", :null => false
    t.column "parent_id",  :integer,   :limit => 10
  end

  add_index "roles", ["parent_id"], :name => "roles_parent_id_index"

  create_table "roles_static_permissions", :id => false, :force => true do |t|
    t.column "role_id",              :integer,   :limit => 10, :default => 0, :null => false
    t.column "static_permission_id", :integer,   :limit => 10, :default => 0, :null => false
    t.column "created_at",           :timestamp,                              :null => false
  end

  add_index "roles_static_permissions", ["static_permission_id", "role_id"], :name => "roles_static_permissions_all_index", :unique => true
  add_index "roles_static_permissions", ["role_id"], :name => "role_id"

  create_table "roles_users", :id => false, :force => true do |t|
    t.column "user_id",    :integer,   :limit => 10, :default => 0, :null => false
    t.column "role_id",    :integer,   :limit => 10, :default => 0, :null => false
    t.column "created_at", :timestamp,                              :null => false
  end

  add_index "roles_users", ["user_id", "role_id"], :name => "roles_users_all_index", :unique => true
  add_index "roles_users", ["role_id"], :name => "role_id"

  create_table "sessions", :force => true do |t|
    t.column "session_id", :string
    t.column "data",       :text
    t.column "updated_at", :datetime
  end

  add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"
  add_index "sessions", ["updated_at"], :name => "index_sessions_on_updated_at"

  create_table "snippets", :force => true do |t|
    t.column "title",      :string
    t.column "body",       :text
    t.column "created_on", :datetime
    t.column "updated_on", :datetime
    t.column "key",        :string
  end

  create_table "static_permissions", :force => true do |t|
    t.column "title",      :string,    :limit => 200, :default => "", :null => false
    t.column "created_at", :timestamp,                                :null => false
    t.column "updated_at", :timestamp,                                :null => false
  end

  add_index "static_permissions", ["title"], :name => "static_permissions_title_index", :unique => true

  create_table "taggings", :force => true do |t|
    t.column "tag_id",        :integer,                     :null => false
    t.column "taggable_id",   :integer,                     :null => false
    t.column "taggable_type", :string,   :default => "",    :null => false
    t.column "hide_tag",      :boolean,  :default => false, :null => false
    t.column "event_date",    :datetime
  end

  add_index "taggings", ["tag_id", "taggable_id", "taggable_type"], :name => "index_taggings_on_tag_id_and_taggable_id_and_taggable_type", :unique => true

  create_table "tags", :force => true do |t|
    t.column "name", :string, :default => "", :null => false
  end

  add_index "tags", ["name"], :name => "index_tags_on_name", :unique => true

  create_table "user_registrations", :force => true do |t|
    t.column "user_id",    :integer,   :limit => 10, :default => 0,  :null => false
    t.column "token",      :text,                    :default => "", :null => false
    t.column "created_at", :timestamp,                               :null => false
    t.column "expires_at", :timestamp,                               :null => false
  end

  add_index "user_registrations", ["user_id"], :name => "user_registrations_user_id_index", :unique => true
  add_index "user_registrations", ["expires_at"], :name => "user_registrations_expires_at_index"

  create_table "users", :force => true do |t|
    t.column "created_at",          :timestamp,                                          :null => false
    t.column "updated_at",          :timestamp,                                          :null => false
    t.column "last_logged_in_at",   :timestamp,                                          :null => false
    t.column "login_failure_count", :integer,   :limit => 10,  :default => 0,            :null => false
    t.column "login",               :string,    :limit => 100, :default => "",           :null => false
    t.column "email",               :string,    :limit => 200, :default => "",           :null => false
    t.column "password",            :string,    :limit => 100, :default => "",           :null => false
    t.column "password_hash_type",  :string,    :limit => 20,  :default => "",           :null => false
    t.column "password_salt",       :string,    :limit => 10,  :default => "1234512345", :null => false
    t.column "state",               :integer,   :limit => 10,  :default => 1,            :null => false
  end

  add_index "users", ["login"], :name => "users_login_index", :unique => true
  add_index "users", ["password"], :name => "users_password_index"

  create_table "videos", :force => true do |t|
    t.column "title",             :string,   :default => "", :null => false
    t.column "file",              :string,   :default => "", :null => false
    t.column "content_id",        :integer
    t.column "created_on",        :datetime
    t.column "updated_on",        :datetime
    t.column "body",              :string
    t.column "processing_status", :integer
  end

  add_index "videos", ["content_id"], :name => "fk_event_video"

end
