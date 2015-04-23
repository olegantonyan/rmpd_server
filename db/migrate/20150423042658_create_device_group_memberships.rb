class CreateDeviceGroupMemberships < ActiveRecord::Migration
  def change
    create_table :device_group_memberships do |t|
      t.string :description, limit: 1024, null: false, default: ""
      t.references :device, index: true, foreign_key: true
      t.references :device_group, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
