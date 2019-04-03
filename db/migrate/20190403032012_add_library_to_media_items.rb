class AddLibraryToMediaItems < ActiveRecord::Migration[6.0]
  def up
    add_column :media_items, :library, :integer, null: false, default: 0
    remove_column :media_items, :library_shared
  end

  def down
    add_column :media_items, :library_shared, :integer, null: false, default: 0
    remove_column :media_items, :library
  end
end
