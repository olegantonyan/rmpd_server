class AddPlaylistForeignKeyToDevice < ActiveRecord::Migration
  def change
    add_reference :devices, :playlist, index: true
  end
end
