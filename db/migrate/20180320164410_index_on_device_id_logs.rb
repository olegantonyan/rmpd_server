class IndexOnDeviceIdLogs < ActiveRecord::Migration[5.1]
  def change
    add_index :device_log_messages, :device_id
  end
end
