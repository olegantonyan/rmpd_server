class CreateMediaDeployments < ActiveRecord::Migration
  def change
    create_table :playlist_items do |t|
      t.references :playlist
      t.references :media_item
      t.timestamps null: false
    end
    add_index :playlist_items, ["playlist_id", "media_item_id"]
  end
end
