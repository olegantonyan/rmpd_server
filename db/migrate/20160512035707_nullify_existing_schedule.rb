class NullifyExistingSchedule < ActiveRecord::Migration[5.0]
  def change
    reversible do |dir|
      dir.up { execute 'UPDATE playlist_items SET schedule = NULL' }
      dir.down {}
    end
  end
end
