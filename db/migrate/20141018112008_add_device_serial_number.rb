class AddDeviceSerialNumber < ActiveRecord::Migration
  def change
    add_column :devices, :serial_number, :string, null: false, default: ""
  end
end
