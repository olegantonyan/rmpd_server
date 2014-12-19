class AddMessageQueue < ActiveRecord::Migration
  def change
    create_table :message_queues do |t|
      t.string :key
      t.string :data

      t.timestamps null: false
    end
  end
end
