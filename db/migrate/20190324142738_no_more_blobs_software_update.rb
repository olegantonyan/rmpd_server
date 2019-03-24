class NoMoreBlobsSoftwareUpdate < ActiveRecord::Migration[6.0]
  def up
    remove_column :device_software_updates, :file

    add_column :device_software_updates, :file, :string, null: false
  end

  def down
    add_column :device_software_updates, :file, :binary, null: false
  end
end
