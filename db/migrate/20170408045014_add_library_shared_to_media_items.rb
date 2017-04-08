class AddLibrarySharedToMediaItems < ActiveRecord::Migration[5.0]
  def change
    add_column :media_items, :library_shared, :boolean, null: false, default: false
  end
end
