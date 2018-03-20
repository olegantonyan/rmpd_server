class CreateDeviceGroups < ActiveRecord::Migration[4.2]
  def change
    create_table :device_groups do |t|
      t.string :title, limit: 256, null: false

      t.timestamps null: false
    end
  end
end
