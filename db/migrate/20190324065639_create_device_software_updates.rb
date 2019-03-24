class CreateDeviceSoftwareUpdates < ActiveRecord::Migration[6.0]
  def change
    create_table :device_software_updates do |t|
      t.references :device, foreign_key: true, null: false
      t.string :version, null: false, limit: 1000

      t.timestamps
    end
  end
end
