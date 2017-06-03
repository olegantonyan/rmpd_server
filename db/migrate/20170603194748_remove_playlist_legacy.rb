class RemovePlaylistLegacy < ActiveRecord::Migration[5.1]
  def change
    reversible do |dir|
      dir.up {
        remove_column :playlists, :file
      }
      dir.down {
        add_column :playlists, :file, :string, limit: 256, default: '', null: false
      }
    end
  end
end
