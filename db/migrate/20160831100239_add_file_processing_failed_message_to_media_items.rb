class AddFileProcessingFailedMessageToMediaItems < ActiveRecord::Migration[5.0]
  def change
    add_column :media_items, :file_processing_failed_message, :string, null: true
  end
end
