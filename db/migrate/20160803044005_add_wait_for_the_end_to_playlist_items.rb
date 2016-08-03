class AddWaitForTheEndToPlaylistItems < ActiveRecord::Migration[5.0]
  def change
    add_column :playlist_items, :wait_for_the_end, :boolean, default: false, null: false
  end
end
