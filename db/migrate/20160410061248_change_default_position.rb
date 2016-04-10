class ChangeDefaultPosition < ActiveRecord::Migration[5.0]
  def change
    reversible do |dir|
      dir.up    { change_column_default(:playlist_items, :position, 0) }
      dir.down  { change_column_default(:playlist_items, :position, 1000000) }
    end
  end
end
