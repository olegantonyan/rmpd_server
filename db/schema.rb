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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20160831100239) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "companies", force: :cascade do |t|
    t.string   "title",      limit: 1024, null: false
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  create_table "device_group_memberships", force: :cascade do |t|
    t.string   "description",     limit: 1024, default: "", null: false
    t.integer  "device_id"
    t.integer  "device_group_id"
    t.datetime "created_at",                                null: false
    t.datetime "updated_at",                                null: false
    t.index ["device_group_id"], name: "index_device_group_memberships_on_device_group_id", using: :btree
    t.index ["device_id"], name: "index_device_group_memberships_on_device_id", using: :btree
  end

  create_table "device_groups", force: :cascade do |t|
    t.string   "title",      limit: 256, null: false
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "device_log_messages", force: :cascade do |t|
    t.integer  "device_id"
    t.string   "command",    null: false
    t.datetime "localtime",  null: false
    t.string   "message"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "user_agent"
    t.index ["message"], name: "index_device_log_messages_on_message", using: :btree
  end

  create_table "device_service_uploads", force: :cascade do |t|
    t.string   "file"
    t.string   "reason",     default: "", null: false
    t.integer  "device_id"
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
    t.index ["device_id"], name: "index_device_service_uploads_on_device_id", using: :btree
  end

  create_table "device_statuses", force: :cascade do |t|
    t.boolean  "online",       default: false, null: false
    t.datetime "poweredon_at"
    t.string   "now_playing"
    t.integer  "device_id"
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
    t.datetime "devicetime"
    t.bigint   "free_space"
    t.index ["device_id"], name: "index_device_statuses_on_device_id", using: :btree
  end

  create_table "deviceapi_message_queue", force: :cascade do |t|
    t.string   "key"
    t.string   "data"
    t.boolean  "dequeued",          default: false
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
    t.integer  "reenqueue_retries", default: 0,     null: false
    t.string   "message_type"
    t.index ["key"], name: "index_deviceapi_message_queue_on_key", using: :btree
    t.index ["message_type"], name: "index_deviceapi_message_queue_on_message_type", using: :btree
  end

  create_table "devices", force: :cascade do |t|
    t.string   "login"
    t.string   "name"
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
    t.integer  "playlist_id"
    t.string   "password_digest"
    t.integer  "company_id"
    t.string   "time_zone",       default: "", null: false
    t.string   "wallpaper"
    t.index ["company_id"], name: "index_devices_on_company_id", using: :btree
    t.index ["login"], name: "index_devices_on_login", using: :btree
    t.index ["playlist_id"], name: "index_devices_on_playlist_id", using: :btree
  end

  create_table "invites", force: :cascade do |t|
    t.string   "email",                      null: false
    t.string   "token",                      null: false
    t.integer  "company_id"
    t.integer  "user_id"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.boolean  "accepted",   default: false, null: false
    t.index ["company_id"], name: "index_invites_on_company_id", using: :btree
    t.index ["user_id"], name: "index_invites_on_user_id", using: :btree
  end

  create_table "media_items", force: :cascade do |t|
    t.string   "file",                                           null: false
    t.text     "description",                    default: "",    null: false
    t.datetime "created_at",                                     null: false
    t.datetime "updated_at",                                     null: false
    t.integer  "company_id"
    t.boolean  "file_processing",                default: false, null: false
    t.integer  "type",                           default: 0,     null: false
    t.boolean  "volume_normalized",              default: false, null: false
    t.string   "file_processing_failed_message"
    t.index ["company_id"], name: "index_media_items_on_company_id", using: :btree
  end

  create_table "news_items", force: :cascade do |t|
    t.text     "body",                                null: false
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.string   "title",      limit: 128, default: "", null: false
  end

  create_table "playlist_items", force: :cascade do |t|
    t.integer  "playlist_id"
    t.integer  "media_item_id"
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
    t.integer  "position",          default: 0
    t.time     "begin_time"
    t.time     "end_time"
    t.integer  "playbacks_per_day"
    t.date     "begin_date"
    t.date     "end_date"
    t.text     "schedule"
    t.boolean  "wait_for_the_end",  default: false, null: false
    t.integer  "show_duration"
    t.index ["playlist_id", "media_item_id"], name: "index_playlist_items_on_playlist_id_and_media_item_id", using: :btree
  end

  create_table "playlists", force: :cascade do |t|
    t.string   "name",                                    null: false
    t.text     "description",             default: "",    null: false
    t.datetime "created_at",                              null: false
    t.datetime "updated_at",                              null: false
    t.string   "file",        limit: 256, default: "",    null: false
    t.integer  "company_id"
    t.boolean  "shuffle",                 default: false, null: false
    t.index ["company_id"], name: "index_playlists_on_company_id", using: :btree
    t.index ["name"], name: "index_playlists_on_name", using: :btree
  end

  create_table "user_company_memberships", force: :cascade do |t|
    t.string   "title"
    t.integer  "user_id"
    t.integer  "company_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["company_id"], name: "index_user_company_memberships_on_company_id", using: :btree
    t.index ["user_id"], name: "index_user_company_memberships_on_user_id", using: :btree
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "",    null: false
    t.string   "encrypted_password",     default: "",    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.string   "displayed_name",         default: "",    null: false
    t.boolean  "allow_notifications",    default: false, null: false
    t.boolean  "root",                   default: false, null: false
    t.string   "authentication_token"
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true, using: :btree
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
    t.index ["root"], name: "index_users_on_root", using: :btree
  end

  create_table "versions", force: :cascade do |t|
    t.string   "item_type",      null: false
    t.integer  "item_id",        null: false
    t.string   "event",          null: false
    t.string   "whodunnit"
    t.text     "object"
    t.datetime "created_at"
    t.text     "object_changes"
    t.integer  "transaction_id"
    t.index ["item_type", "item_id"], name: "index_versions_on_item_type_and_item_id", using: :btree
    t.index ["transaction_id"], name: "index_versions_on_transaction_id", using: :btree
  end

  add_foreign_key "device_service_uploads", "devices"
  add_foreign_key "invites", "companies"
  add_foreign_key "invites", "users"
  add_foreign_key "playlist_items", "media_items"
  add_foreign_key "playlist_items", "playlists"
end
