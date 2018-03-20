class AddScheduleToPlaylistItems < ActiveRecord::Migration[4.2]
  def change
    add_column :playlist_items, :schedule, :text
  end
end
