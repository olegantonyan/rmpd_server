class MediaItemProcessingWorker # becasuse I need `sidekiq_retries_exhausted`
  include Sidekiq::Worker

  sidekiq_options queue: :files_processing, retry: 5

  def perform(media_item_id, skip_volume_normalization = false)
    MediaItem::Processing.new(media_item: MediaItem.find(media_item_id), skip_volume_normalization: skip_volume_normalization).call
  end

  sidekiq_retries_exhausted do |msg|
    media_item = MediaItem.find_by(id: msg['args'].first)
    error_message = msg['error_message'].presence || 'unkown error'
    media_item&.file_processing_failed!(error_message)
  end
end
