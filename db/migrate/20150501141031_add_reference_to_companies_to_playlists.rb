class AddReferenceToCompaniesToPlaylists < ActiveRecord::Migration[4.2]
  def change
    change_table :playlists do |t|
      t.references :company, index: true
    end
  end
end
