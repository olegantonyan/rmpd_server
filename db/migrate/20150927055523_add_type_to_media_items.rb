class AddTypeToMediaItems < ActiveRecord::Migration[4.2]
  def change
    add_column :media_items, :type, :integer, null: false, default: 0
  end
end
