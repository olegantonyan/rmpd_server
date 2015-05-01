class AddReferenceToCompaniesToPlaylists < ActiveRecord::Migration
  def change
    change_table :playlists do |t|
      t.references :company, index: true
    end
  end
end
