class AddDevicePasswordAndRemoveSerial < ActiveRecord::Migration[4.2]
  def up
    remove_column :devices, :serial_number
    add_column :devices, :password_digest, :string
  end

  def down
    add_column :devices, :serial_number, :string, default: "", null: false
    remove_column :devices, :password_digest
  end
end
