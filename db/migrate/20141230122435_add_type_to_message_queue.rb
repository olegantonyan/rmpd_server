class AddTypeToMessageQueue < ActiveRecord::Migration
  def change
    add_column :message_queues, :message_type, :string
    add_index :message_queues, :message_type
  end
end
