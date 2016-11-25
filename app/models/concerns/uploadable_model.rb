module UploadableModel
  extend ActiveSupport::Concern

  included do
    before_validation :attach_file, on: :create, if: -> { upload_uuid.present? }
  end

  attr_accessor :upload_uuid, :upload_original_filename, :upload_content_type

  private

  def attach_file
    send("#{file_field}=", Upload.file(upload_uuid, upload_original_filename, upload_content_type))
  end

  def file_field
    if respond_to?(:uploadable_file_field)
      send(:uploadable_file_field)
    else
      :file
    end
  end
end
