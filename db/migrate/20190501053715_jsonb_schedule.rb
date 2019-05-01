class JsonbSchedule < ActiveRecord::Migration[6.0]
  def up
    remove_column :playlist_items, :schedule
    add_column :playlist_items, :schedule, :jsonb
  end

  def down
    remove_column :playlist_items, :schedule
    add_column :playlist_items, :schedule, :text
  end
end
