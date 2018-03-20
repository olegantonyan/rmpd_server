class RenameMessageQueues < ActiveRecord::Migration[4.2]
  def change
    change_column_default :message_queues, :reenqueue_retries, 0
    change_column_default :message_queues, :dequeued, false
    change_column_null :message_queues, :reenqueue_retries, false
    rename_table :message_queues, :deviceapi_message_queue
  end
end
