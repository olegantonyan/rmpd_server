class AddRetriesToMessqgeQueue < ActiveRecord::Migration
  def change
    add_column :message_queues, :reenqueue_retries, :integer
    add_column :message_queues, :message, :string
  end
end
