class Api::MediaItemResource < Api::BaseResource
  include Api::Concerns::UploadableResource

  attributes :description, :file_identifier, :file_processing, :volume_normalized, :file_processing_failed_message, :content_type, :size, :duration, :file_url
  attribute :_type, delegate: :type

  has_one :company

  filter :type

  def duration
    model.duration.total
  end

  def self.updatable_fields(context)
    super - %i(file_identifier file_processing file_processing_failed_message content_type size duration volume_normalized file_url)
  end

  def self.creatable_fields(context)
    updatable_fields(context)
  end
end
