class AddIndexToDevicesLogin < ActiveRecord::Migration
  def change
    add_index :devices, :login
  end
end
