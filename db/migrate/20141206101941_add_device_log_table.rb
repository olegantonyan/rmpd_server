class AddDeviceLogTable < ActiveRecord::Migration
  def change
    create_table :device_logs do |t|
      t.string :module, null: false
      t.string :class, null: false
      t.string :type, null: false
      t.datetime :localtime, null: false
      t.string :details
      t.timestamps null: false
    end
    add_index :device_logs, :module
    add_index :device_logs, :details
  end
end
