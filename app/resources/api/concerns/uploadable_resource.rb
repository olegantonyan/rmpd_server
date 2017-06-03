module Api
  module Concerns
    module UploadableResource
      extend ActiveSupport::Concern

      included do
        attributes :upload_uuid, :upload_original_filename, :upload_content_type
      end

      def fetchable_fields
        super - %i[upload_uuid upload_original_filename upload_content_type]
      end
    end
  end
end
