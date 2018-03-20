class AddDeviceLogTable < ActiveRecord::Migration[4.2]
  def change
    create_table :device_logs do |t|
      t.references :device
      t.string :module, null: false
      t.string :level, null: false
      t.string :etype, null: false
      t.datetime :localtime, null: false
      t.string :details
      t.timestamps null: false
    end
    add_index :device_logs, :module
    add_index :device_logs, :level
    add_index :device_logs, :details
  end
end
