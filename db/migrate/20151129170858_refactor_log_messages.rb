class RefactorLogMessages < ActiveRecord::Migration[4.2]
  def change
    rename_column :device_log_messages, :type, :command
    rename_column :device_log_messages, :details, :message
    reversible do |dir|
      dir.up {
        remove_column :device_log_messages, :module
        remove_column :device_log_messages, :level
      }
      dir.down {
        add_column :device_log_messages, :module, :string, null: false, default: ''
        add_column :device_log_messages, :level, :string, null: false, default: ''
      }
    end
  end
end
