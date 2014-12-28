class CreateDeviceCommandStatuses < ActiveRecord::Migration
  def change
    create_table :device_command_statuses do |t|
      t.integer :device_id
      t.string :command
      t.string :status
      t.string :message

      t.timestamps null: false
    end
  end
end
