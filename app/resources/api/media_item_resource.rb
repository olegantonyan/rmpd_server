class Api::MediaItemResource < Api::BaseResource
  attributes :description, :file_identifier, :file_processing, :type, :volume_normalized, :file_processing_failed_message
end
