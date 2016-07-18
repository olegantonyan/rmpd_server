class AddFreeSpaceToDeviceStatuses < ActiveRecord::Migration[5.0]
  def change
    add_column :device_statuses, :free_space, :integer, limit: 8
  end
end
