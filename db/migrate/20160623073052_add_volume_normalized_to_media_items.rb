class AddVolumeNormalizedToMediaItems < ActiveRecord::Migration[5.0]
  def change
    add_column :media_items, :volume_normalized, :boolean, null: false, default: false
  end
end
