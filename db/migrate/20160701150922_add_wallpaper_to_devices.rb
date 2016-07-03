class AddWallpaperToDevices < ActiveRecord::Migration[5.0]
  def change
    add_column :devices, :wallpaper, :string
  end
end
