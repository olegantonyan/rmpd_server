class AddDurationToPlaylistItems < ActiveRecord::Migration[5.0]
  def change
    add_column :playlist_items, :show_duration, :integer
  end
end
