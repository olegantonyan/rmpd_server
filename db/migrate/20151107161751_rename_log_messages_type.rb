class RenameLogMessagesType < ActiveRecord::Migration
  def change
    rename_column :device_log_messages, :etype, :type
  end
end
