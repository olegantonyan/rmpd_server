class CreateDeviceServiceUploads < ActiveRecord::Migration[5.0]
  def change
    create_table :device_service_uploads do |t|
      t.string :file
      t.string :reason, null: false, default: ''
      t.references :device, foreign_key: true, index: true

      t.timestamps
    end
  end
end
