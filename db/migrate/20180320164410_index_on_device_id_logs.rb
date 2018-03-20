class IndexOnDeviceIdLogs < ActiveRecord::Migration[5.1]
  def up
    add_index :device_log_messages, :device_id
  end

  def down
    remove_index :device_log_messages, :device_id
  end
end
