class RenameDeviceLogsToDeviceLogMessages < ActiveRecord::Migration
  def change
    rename_table :device_logs, :device_log_messages
  end
end
