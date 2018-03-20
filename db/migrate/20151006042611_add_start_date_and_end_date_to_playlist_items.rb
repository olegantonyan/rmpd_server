class AddStartDateAndEndDateToPlaylistItems < ActiveRecord::Migration[4.2]
  def change
    add_column :playlist_items, :begin_date, :date
    add_column :playlist_items, :end_date, :date
    rename_column :playlist_items, :playbacks_total, :playbacks_per_day
  end
end
