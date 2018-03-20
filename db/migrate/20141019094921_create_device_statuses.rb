class CreateDeviceStatuses < ActiveRecord::Migration[4.2]
  def change
    create_table :device_statuses do |t|
      t.boolean :online, null: false, default: false
      t.datetime :last_seen
      t.datetime :uptime
      t.string :now_playing
      t.references :device, index: true

      t.timestamps null: false
    end
  end
end
