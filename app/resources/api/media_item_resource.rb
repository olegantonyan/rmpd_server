class Api::MediaItemResource < Api::BaseResource
  include Api::Concerns::AuthorizableResource

  attributes :description, :file_identifier, :file_processing, :volume_normalized, :file_processing_failed_message, :content_type, :size, :duration
  attribute :_type, delegate: :type

  has_one :company

  def duration
    model.duration.total
  end
end
