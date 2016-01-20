class AddTimezoneToDevices < ActiveRecord::Migration
  def change
    add_column :devices, :time_zone, :string, default: '', null: false
  end
end
