class MediaItemProcessingJob < ApplicationJob
  queue_as :files_processing

  rescue_from(ActiveRecord::RecordNotFound) {}

  def perform(media_item, skip_volume_normalization = false)
    MediaItem::Processing.new(media_item: media_item, skip_volume_normalization: skip_volume_normalization).call
  end
end
