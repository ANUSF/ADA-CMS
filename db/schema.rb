# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20110315011631) do

  create_table "archive_studies", :force => true do |t|
    t.integer  "study_id"
    t.integer  "archive_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "archive_study_blocks", :force => true do |t|
    t.integer  "study_query_id"
    t.string   "ddi_id",         :null => false
    t.integer  "archive_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "archive_study_integrations", :force => true do |t|
    t.integer  "study_id"
    t.integer  "archive_study_id"
    t.integer  "archive_study_query_id"
    t.string   "ddi_id",                 :null => false
    t.integer  "archive_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "archive_study_queries", :force => true do |t|
    t.integer  "archive_id", :null => false
    t.string   "name",       :null => false
    t.text     "query",      :null => false
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "archives", :force => true do |t|
    t.string   "name",       :null => false
    t.string   "slug",       :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "ddi_mappings", :force => true do |t|
    t.string   "ddi"
    t.string   "human_readable"
    t.text     "description"
    t.boolean  "xml_element"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "inkling_can_can_actions", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "inkling_feed_roles", :force => true do |t|
    t.datetime "created_at", :null => false
    t.string   "title",      :null => false
    t.integer  "feed_id",    :null => false
    t.integer  "role_id",    :null => false
  end

  create_table "inkling_feeds", :force => true do |t|
    t.datetime "created_at", :null => false
    t.integer  "user_id",    :null => false
    t.string   "title",      :null => false
    t.string   "format",     :null => false
    t.string   "source",     :null => false
    t.string   "criteria"
  end

  create_table "inkling_logs", :force => true do |t|
    t.datetime "created_at"
    t.text     "text",       :null => false
    t.integer  "user_id"
    t.string   "category",   :null => false
  end

  create_table "inkling_paths", :force => true do |t|
    t.integer  "parent_id"
    t.integer  "lft"
    t.integer  "rgt"
    t.string   "slug",         :null => false
    t.integer  "content_id"
    t.string   "content_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "inkling_permissions", :force => true do |t|
    t.integer  "type_id"
    t.integer  "role_id",           :null => false
    t.integer  "can_can_action_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "inkling_role_memberships", :force => true do |t|
    t.integer "user_id", :null => false
    t.integer "role_id", :null => false
  end

  create_table "inkling_roles", :force => true do |t|
    t.string   "name",       :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "inkling_themes", :force => true do |t|
    t.string   "name",                                :null => false
    t.text     "body"
    t.string   "extension",  :default => ".html.erb", :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "inkling_types", :force => true do |t|
    t.string   "klass_name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "inkling_users", :force => true do |t|
    t.string   "email",                               :default => "", :null => false
    t.string   "encrypted_password",   :limit => 128, :default => "", :null => false
    t.string   "password_salt",                       :default => "", :null => false
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "reset_password_token"
    t.string   "remember_token"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                       :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "username"
    t.string   "firstname"
    t.string   "surname"
  end

  create_table "media", :force => true do |t|
    t.integer  "user_id"
    t.string   "title",              :null => false
    t.string   "asset_file_name"
    t.string   "asset_content_type"
    t.integer  "asset_file_size"
    t.datetime "asset_updated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "media", ["title"], :name => "index_media_on_title", :unique => true
  add_index "media", ["user_id"], :name => "index_media_on_user_id"

  create_table "news", :force => true do |t|
    t.integer  "user_id"
    t.string   "title",                                           :null => false
    t.text     "body",                                            :null => false
    t.string   "state",                      :default => "draft", :null => false
    t.string   "keywords",   :limit => 1024
    t.datetime "publish_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "news", ["user_id"], :name => "index_news_on_user_id"

  create_table "news_archives", :force => true do |t|
    t.integer  "news_id"
    t.integer  "archive_id"
    t.string   "foo"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "news_archives", ["archive_id", "news_id"], :name => "index_news_archives_on_archive_id_and_news_id"
  add_index "news_archives", ["news_id", "archive_id"], :name => "index_news_archives_on_news_id_and_archive_id"

  create_table "pages", :force => true do |t|
    t.string   "title",                           :null => false
    t.string   "link_title",                      :null => false
    t.text     "description"
    t.integer  "author_id",                       :null => false
    t.text     "body"
    t.text     "breakout_box"
    t.integer  "parent_id"
    t.integer  "archive_id"
    t.string   "partial"
    t.integer  "lft"
    t.integer  "rgt"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "state"
    t.integer  "archive_to_study_integration_id"
  end

  create_table "studies", :force => true do |t|
    t.string   "label"
    t.string   "resource"
    t.string   "study3"
    t.string   "about"
    t.boolean  "published"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "universe"
    t.string   "collection_date"
    t.string   "id_number"
    t.text     "series_name"
    t.text     "topics"
    t.string   "country"
    t.text     "geo_coverage"
    t.text     "investigator"
    t.string   "language"
    t.text     "abstract"
    t.text     "keywords"
    t.integer  "page_id"
    t.string   "data_kind"
    t.string   "sampling"
    t.string   "collection_mode"
  end

  create_table "study_fields", :force => true do |t|
    t.integer  "study_id"
    t.string   "key"
    t.text     "value"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "study_related_materials", :force => true do |t|
    t.integer  "study_id"
    t.string   "uri"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "comment"
    t.text     "creation_date"
    t.boolean  "complete"
    t.text     "resource"
  end

end
