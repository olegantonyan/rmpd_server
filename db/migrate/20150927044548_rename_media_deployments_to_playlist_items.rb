class RenameMediaDeploymentsToPlaylistItems < ActiveRecord::Migration
  def change
    rename_table :playlist_items, :playlist_items
    rename_column :playlist_items, :playlist_position, :position
  end
end
