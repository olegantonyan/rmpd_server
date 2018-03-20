class AddFileProcessingFlagToMediaItems < ActiveRecord::Migration[4.2]
  def change
    add_column :media_items, :file_processing, :boolean, null: false, default: false
  end
end
