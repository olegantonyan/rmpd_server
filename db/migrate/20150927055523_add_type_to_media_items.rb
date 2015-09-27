class AddTypeToMediaItems < ActiveRecord::Migration
  def change
    add_column :media_items, :type, :integer, null: false, default: 0
  end
end
