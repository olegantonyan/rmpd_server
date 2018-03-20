class AddPlaylistForeignKeyToDevice < ActiveRecord::Migration[4.2]
  def change
    add_reference :devices, :playlist, index: true
  end
end
