class AddDevicetimeToStatus < ActiveRecord::Migration[4.2]
  def change
    add_column :device_statuses, :devicetime, :datetime
  end
end
