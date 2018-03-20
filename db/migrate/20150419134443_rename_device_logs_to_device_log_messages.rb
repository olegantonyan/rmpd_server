class RenameDeviceLogsToDeviceLogMessages < ActiveRecord::Migration[4.2]
  def change
    rename_table :device_logs, :device_log_messages
  end
end
