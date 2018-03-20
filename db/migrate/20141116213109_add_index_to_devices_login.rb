class AddIndexToDevicesLogin < ActiveRecord::Migration[4.2]
  def change
    add_index :devices, :login
  end
end
