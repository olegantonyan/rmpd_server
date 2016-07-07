class AddForiegnKeysToPlaylistItems < ActiveRecord::Migration[5.0]
  def change
    reversible do |dir|
      dir.up {
        execute <<-SQL
        DELETE FROM playlist_items WHERE id IN (SELECT p.id FROM playlist_items p LEFT JOIN media_items m ON m.id = p.media_item_id WHERE m.id IS NULL)
        SQL
      }
      dir.down {}
    end
    add_foreign_key :playlist_items, :media_items
    add_foreign_key :playlist_items, :playlists
  end
end
