class AddDurationToMediaItems < ActiveRecord::Migration[5.0]
  def change
    add_column :media_items, :duration, :integer, null: false, default: 0
  end
end
