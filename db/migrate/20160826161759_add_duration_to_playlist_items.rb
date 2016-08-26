class AddDurationToPlaylistItems < ActiveRecord::Migration[5.0]
  def change
    add_column :playlist_items, :duration, :integer
  end
end
