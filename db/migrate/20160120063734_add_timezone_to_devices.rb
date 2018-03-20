class AddTimezoneToDevices < ActiveRecord::Migration[4.2]
  def change
    add_column :devices, :time_zone, :string, default: '', null: false
  end
end
