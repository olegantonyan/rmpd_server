class RenameMediaDeploymentsToPlaylistItems < ActiveRecord::Migration
  def change
    rename_table :media_deployments, :playlist_items
    rename_column :playlist_items, :playlist_position, :position
  end
end
