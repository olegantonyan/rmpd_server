class AddM3UFileToPlaylist < ActiveRecord::Migration
  def change
    add_column :playlists, :file, :string, after: :name, null: false, default: "", :limit => 256
  end
end
