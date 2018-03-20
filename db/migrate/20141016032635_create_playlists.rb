class CreatePlaylists < ActiveRecord::Migration[4.2]
  def change
    create_table :playlists do |t|
      t.string :name, null: false
      t.string :description, null: false, default: ""
      t.timestamps null: false
    end
    add_index :playlists, :name
  end
end
