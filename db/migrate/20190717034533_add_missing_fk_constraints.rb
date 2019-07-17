class AddMissingFkConstraints < ActiveRecord::Migration[6.0]
  def change
    add_foreign_key :devices, :companies
    add_foreign_key :devices, :playlists

    add_foreign_key :device_log_messages, :devices

    add_foreign_key :media_items, :companies

    add_foreign_key :playlists, :companies
  end
end
