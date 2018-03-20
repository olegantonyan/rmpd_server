class AddBeginTimeAndOthersToPlaylists < ActiveRecord::Migration[4.2]
  def change
    change_table :playlist_items do |t|
      t.time :begin_time
      t.time :end_time
      t.integer :playbacks_total
    end
  end
end
