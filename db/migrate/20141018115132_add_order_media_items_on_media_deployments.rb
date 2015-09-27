class AddOrderMediaItemsOnMediaDeployments < ActiveRecord::Migration
  def change
    add_column :playlist_items, :playlist_position, :integer, after: :media_item_id, default: 1000000
  end
end
