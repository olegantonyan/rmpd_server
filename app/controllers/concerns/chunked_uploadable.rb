module ChunkedUploadable
  extend ActiveSupport::Concern

  def chunked_upload(file)
    ChunkedUpload.new(file, request.headers['Content-Range'], File.join(Rails.root, 'public', 'uploads', 'tmp', 'chunked', current_user&.id&.to_s || 'anonymous'))
  end
end
