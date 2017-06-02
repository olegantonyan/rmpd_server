class AddUniqConstraintToLogs < ActiveRecord::Migration[5.0]
  def change
    add_index :device_log_messages, %i[localtime device_id message command], unique: true, name: 'uniq_message'
  end
end
