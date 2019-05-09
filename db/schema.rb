# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2019_05_09_053056) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "companies", id: :serial, force: :cascade do |t|
    t.string "title", limit: 1024, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "device_group_memberships", id: :serial, force: :cascade do |t|
    t.string "description", limit: 1024, default: "", null: false
    t.integer "device_id"
    t.integer "device_group_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["device_group_id"], name: "index_device_group_memberships_on_device_group_id"
    t.index ["device_id"], name: "index_device_group_memberships_on_device_id"
  end

  create_table "device_groups", id: :serial, force: :cascade do |t|
    t.string "title", limit: 256, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "device_log_messages", id: :serial, force: :cascade do |t|
    t.integer "device_id"
    t.string "command", null: false
    t.datetime "localtime", null: false
    t.string "message"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "user_agent"
    t.index ["device_id"], name: "index_device_log_messages_on_device_id"
  end

  create_table "device_software_updates", force: :cascade do |t|
    t.bigint "device_id", null: false
    t.string "version", limit: 1000, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["device_id"], name: "index_device_software_updates_on_device_id"
  end

  create_table "deviceapi_message_queue", id: :serial, force: :cascade do |t|
    t.string "key"
    t.text "data"
    t.boolean "dequeued", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "reenqueue_retries", default: 0, null: false
    t.string "message_type"
    t.index ["key"], name: "index_deviceapi_message_queue_on_key"
    t.index ["message_type"], name: "index_deviceapi_message_queue_on_message_type"
  end

  create_table "devices", id: :serial, force: :cascade do |t|
    t.string "login"
    t.string "name", default: ""
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "playlist_id"
    t.string "password_digest"
    t.integer "company_id"
    t.string "time_zone", default: "", null: false
    t.boolean "online", default: false, null: false
    t.datetime "poweredon_at"
    t.string "now_playing", default: "", null: false
    t.datetime "devicetime"
    t.bigint "free_space", default: 0, null: false
    t.string "webui_password", default: "", null: false
    t.string "ip_addr", limit: 512, default: "", null: false
    t.index ["company_id"], name: "index_devices_on_company_id"
    t.index ["login"], name: "index_devices_on_login"
    t.index ["playlist_id"], name: "index_devices_on_playlist_id"
  end

  create_table "invites", id: :serial, force: :cascade do |t|
    t.string "email", null: false
    t.string "token", null: false
    t.integer "company_id"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "accepted", default: false, null: false
    t.index ["company_id"], name: "index_invites_on_company_id"
    t.index ["user_id"], name: "index_invites_on_user_id"
  end

  create_table "media_items", id: :serial, force: :cascade do |t|
    t.string "description", default: "", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "company_id"
    t.integer "type", default: 0, null: false
    t.boolean "volume_normalized", default: false, null: false
    t.integer "duration", default: 0, null: false
    t.integer "library", default: 0, null: false
    t.index ["company_id"], name: "index_media_items_on_company_id"
    t.index ["description"], name: "index_media_items_on_description"
    t.index ["type"], name: "index_media_items_on_type"
  end

  create_table "playlist_items", id: :serial, force: :cascade do |t|
    t.integer "playlist_id"
    t.integer "media_item_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "position", default: 0
    t.time "begin_time"
    t.time "end_time"
    t.integer "playbacks_per_day"
    t.date "begin_date"
    t.date "end_date"
    t.boolean "wait_for_the_end", default: false, null: false
    t.jsonb "schedule"
    t.index ["playlist_id", "media_item_id"], name: "index_playlist_items_on_playlist_id_and_media_item_id"
  end

  create_table "playlists", id: :serial, force: :cascade do |t|
    t.string "name", null: false
    t.string "description", default: "", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "company_id"
    t.boolean "shuffle", default: false, null: false
    t.index ["company_id"], name: "index_playlists_on_company_id"
    t.index ["name"], name: "index_playlists_on_name"
  end

  create_table "taggings", id: :serial, force: :cascade do |t|
    t.integer "tag_id"
    t.string "taggable_type"
    t.integer "taggable_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["tag_id"], name: "index_taggings_on_tag_id"
    t.index ["taggable_type", "taggable_id"], name: "index_taggings_on_taggable_type_and_taggable_id"
  end

  create_table "tags", id: :serial, force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_tags_on_name", unique: true
  end

  create_table "user_company_memberships", id: :serial, force: :cascade do |t|
    t.string "title"
    t.integer "user_id"
    t.integer "company_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["company_id"], name: "index_user_company_memberships_on_company_id"
    t.index ["user_id"], name: "index_user_company_memberships_on_user_id"
  end

  create_table "users", id: :serial, force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.string "displayed_name", default: "", null: false
    t.boolean "root", default: false, null: false
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["root"], name: "index_users_on_root"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "device_group_memberships", "device_groups"
  add_foreign_key "device_group_memberships", "devices"
  add_foreign_key "device_software_updates", "devices"
  add_foreign_key "invites", "companies"
  add_foreign_key "invites", "users"
  add_foreign_key "playlist_items", "media_items"
  add_foreign_key "playlist_items", "playlists"
  add_foreign_key "taggings", "tags"
  add_foreign_key "user_company_memberships", "companies"
  add_foreign_key "user_company_memberships", "users"
end
