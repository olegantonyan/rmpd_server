class AddRetriesToMessageQueue < ActiveRecord::Migration
  def change
    add_column :message_queues, :reenqueue_retries, :integer
  end
end
