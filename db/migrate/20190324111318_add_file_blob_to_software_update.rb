class AddFileBlobToSoftwareUpdate < ActiveRecord::Migration[6.0]
  def change
    add_column :device_software_updates, :file, :binary, null: false
  end
end
