class AddMessageQueue < ActiveRecord::Migration[4.2]
  def change
    create_table :message_queues do |t|
      t.string :key
      t.text :data
      t.boolean :dequeued

      t.timestamps null: false
    end
    add_index :message_queues, :key
  end
end
