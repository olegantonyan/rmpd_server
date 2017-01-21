module ChunkedUploadable
  extend ActiveSupport::Concern

  def chunked_upload(file)
    ChunkedUpload.new(file, request.headers['Content-Range'], Rails.root.join('public', 'uploads', 'tmp', 'chunked', current_user&.id&.to_s || 'anonymous'))
  end
end
