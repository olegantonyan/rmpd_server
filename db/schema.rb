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

ActiveRecord::Schema.define(version: 20141026201320) do

  create_table "device_statuses", force: true do |t|
    t.boolean  "online",      default: false, null: false
    t.datetime "uptime"
    t.string   "now_playing"
    t.integer  "device_id"
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
  end

  add_index "device_statuses", ["device_id"], name: "index_device_statuses_on_device_id"

  create_table "devices", force: true do |t|
    t.string   "login"
    t.string   "name"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.integer  "playlist_id"
    t.string   "serial_number", default: "", null: false
  end

  add_index "devices", ["playlist_id"], name: "index_devices_on_playlist_id"

  create_table "media_deployments", force: true do |t|
    t.integer  "playlist_id"
    t.integer  "media_item_id"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.integer  "playlist_position", default: 1000000
  end

  add_index "media_deployments", ["playlist_id", "media_item_id"], name: "index_media_deployments_on_playlist_id_and_media_item_id"

  create_table "media_items", force: true do |t|
    t.string   "file",                     null: false
    t.text     "description", default: "", null: false
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  create_table "playlists", force: true do |t|
    t.string   "name",                                 null: false
    t.text     "description",             default: "", null: false
    t.datetime "created_at",                           null: false
    t.datetime "updated_at",                           null: false
    t.string   "file",        limit: 256, default: "", null: false
  end

  add_index "playlists", ["name"], name: "index_playlists_on_name"

end
