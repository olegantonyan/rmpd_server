class AddMessageQueueSyncPeriodToDevices < ActiveRecord::Migration[5.0]
  def change
    add_column :devices, :message_queue_sync_period, :integer, null: true
  end
end
