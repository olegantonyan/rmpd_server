class AddFileProcessingFlagToMediaItems < ActiveRecord::Migration
  def change
    add_column :media_items, :file_processing, :boolean, null: false, default: false
  end
end
