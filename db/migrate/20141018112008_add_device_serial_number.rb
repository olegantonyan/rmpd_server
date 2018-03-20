class AddDeviceSerialNumber < ActiveRecord::Migration[4.2]
  def change
    add_column :devices, :serial_number, :string, null: false, default: ""
  end
end
