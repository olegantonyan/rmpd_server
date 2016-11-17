module Api::Concerns::Uploadable
  extend ActiveSupport::Concern

  def upload
    Upload.new(request.raw_post, request.headers['Content-Range'], request.headers['X-Upload-Uuid'])
  end
end
