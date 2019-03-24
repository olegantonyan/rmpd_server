class RemoveServiceUploads < ActiveRecord::Migration[6.0]
  def up
    drop_table :device_service_uploads
  end

  def down
    create_table "device_service_uploads", id: :serial, force: :cascade do |t|
      t.string "file"
      t.string "reason", default: "", null: false
      t.integer "device_id"
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
      t.index ["device_id"], name: "index_device_service_uploads_on_device_id"
    end
  end
end
