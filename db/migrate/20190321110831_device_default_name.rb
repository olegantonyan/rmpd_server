class DeviceDefaultName < ActiveRecord::Migration[6.0]
  def up
    change_column_default :devices, :name, ''
  end

  def down
    change_column_default :devices, :name, nil
  end
end
