class CreateMediaDeployments < ActiveRecord::Migration
  def change
    create_table :media_deployments do |t|
      t.references :playlist
      t.references :media_item
      t.timestamps null: false
    end
    add_index :media_deployments, ["playlist_id", "media_item_id"]
  end
end
