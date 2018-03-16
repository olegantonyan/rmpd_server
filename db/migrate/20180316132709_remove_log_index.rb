class RemoveLogIndex < ActiveRecord::Migration[5.1]
  def up
    remove_index :device_log_messages, name: 'index_device_log_messages_on_message'
    remove_index :device_log_messages, name: 'uniq_message'
  end

  def down
  end
end
