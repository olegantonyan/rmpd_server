# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20150425130958) do

  create_table "delayed_jobs", force: :cascade do |t|
    t.integer  "priority",   default: 0, null: false
    t.integer  "attempts",   default: 0, null: false
    t.text     "handler",                null: false
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "delayed_jobs", ["priority", "run_at"], name: "delayed_jobs_priority"

  create_table "device_group_memberships", force: :cascade do |t|
    t.string   "description",     limit: 1024, default: "", null: false
    t.integer  "device_id"
    t.integer  "device_group_id"
    t.datetime "created_at",                                null: false
    t.datetime "updated_at",                                null: false
  end

  add_index "device_group_memberships", ["device_group_id"], name: "index_device_group_memberships_on_device_group_id"
  add_index "device_group_memberships", ["device_id"], name: "index_device_group_memberships_on_device_id"

  create_table "device_groups", force: :cascade do |t|
    t.string   "title",      limit: 256, null: false
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "device_log_messages", force: :cascade do |t|
    t.integer  "device_id"
    t.string   "module",     null: false
    t.string   "level",      null: false
    t.string   "etype",      null: false
    t.datetime "localtime",  null: false
    t.string   "details"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "user_agent"
  end

  add_index "device_log_messages", ["details"], name: "index_device_log_messages_on_details"
  add_index "device_log_messages", ["level"], name: "index_device_log_messages_on_level"
  add_index "device_log_messages", ["module"], name: "index_device_log_messages_on_module"

  create_table "device_statuses", force: :cascade do |t|
    t.boolean  "online",       default: false, null: false
    t.datetime "poweredon_at"
    t.string   "now_playing"
    t.integer  "device_id"
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
    t.datetime "devicetime"
  end

  add_index "device_statuses", ["device_id"], name: "index_device_statuses_on_device_id"

  create_table "devices", force: :cascade do |t|
    t.string   "login"
    t.string   "name"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.integer  "playlist_id"
    t.string   "password_digest"
  end

  add_index "devices", ["login"], name: "index_devices_on_login"
  add_index "devices", ["playlist_id"], name: "index_devices_on_playlist_id"

  create_table "media_deployments", force: :cascade do |t|
    t.integer  "playlist_id"
    t.integer  "media_item_id"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.integer  "playlist_position", default: 1000000
  end

  add_index "media_deployments", ["playlist_id", "media_item_id"], name: "index_media_deployments_on_playlist_id_and_media_item_id"

  create_table "media_items", force: :cascade do |t|
    t.string   "file",                     null: false
    t.text     "description", default: "", null: false
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  create_table "message_queues", force: :cascade do |t|
    t.string   "key"
    t.string   "data"
    t.boolean  "dequeued"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.integer  "reenqueue_retries"
    t.string   "message_type"
  end

  add_index "message_queues", ["key"], name: "index_message_queues_on_key"
  add_index "message_queues", ["message_type"], name: "index_message_queues_on_message_type"

  create_table "playlists", force: :cascade do |t|
    t.string   "name",                                 null: false
    t.text     "description",             default: "", null: false
    t.datetime "created_at",                           null: false
    t.datetime "updated_at",                           null: false
    t.string   "file",        limit: 256, default: "", null: false
  end

  add_index "playlists", ["name"], name: "index_playlists_on_name"

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
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
  end

  add_index "users", ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true

end
