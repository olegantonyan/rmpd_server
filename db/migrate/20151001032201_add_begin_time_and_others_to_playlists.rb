class AddBeginTimeAndOthersToPlaylists < ActiveRecord::Migration
  def change
    change_table :playlists do |t|
      t.time :begin_time
      t.time :end_time
      t.integer :playbacks_number
    end
  end
end
