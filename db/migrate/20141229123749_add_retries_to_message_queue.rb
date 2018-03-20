class AddRetriesToMessageQueue < ActiveRecord::Migration[4.2]
  def change
    add_column :message_queues, :reenqueue_retries, :integer
  end
end
