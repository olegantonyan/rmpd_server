class AddDevicetimeToStatus < ActiveRecord::Migration
  def change
    add_column :device_statuses, :devicetime, :datetime
  end
end
