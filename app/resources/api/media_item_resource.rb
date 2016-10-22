class Api::MediaItemResource < Api::BaseResource
  attributes :description, :file_identifier, :file_processing, :media_type, :volume_normalized, :file_processing_failed_message, :content_type, :size, :duration
  has_one :company

  def duration
    model.duration.total
  end

  def media_type
    model.type
  end
end
