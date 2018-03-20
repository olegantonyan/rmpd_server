class RenameLogMessagesType < ActiveRecord::Migration[4.2]
  def change
    rename_column :device_log_messages, :etype, :type
  end
end
