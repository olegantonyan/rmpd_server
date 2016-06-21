class MediaItemProcessingJob < ApplicationJob
  queue_as :files_processing

  rescue_from(ActiveRecord::RecordNotFound) {}

  def perform(media_item)
    MediaItem::Processing.new(media_item: media_item).call
  end
end
