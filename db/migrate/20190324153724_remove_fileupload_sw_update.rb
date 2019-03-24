class RemoveFileuploadSwUpdate < ActiveRecord::Migration[6.0]
  def up
    remove_column :device_software_updates, :file
  end

  def down
    add_column :device_software_updates, :file, :string, null: false
  end
end
