class DeleteLasSeenColumnFromDeviceStatus < ActiveRecord::Migration
  def up
    remove_column :device_statuses, :last_seen
  end
  
  def down
    add_column :device_statuses, :last_seen, :datetime
  end
end
