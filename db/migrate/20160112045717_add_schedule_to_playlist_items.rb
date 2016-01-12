class AddScheduleToPlaylistItems < ActiveRecord::Migration
  def change
    add_column :playlist_items, :schedule, :text
  end
end
