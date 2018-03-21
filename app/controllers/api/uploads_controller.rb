module Api
  class UploadsController < Api::BaseController
    def create
      u = upload
      if u.save
        render json: { uuid: u.uuid }
      else
        render json: { error: 'error uploading file' }, status: :unprocessable_entity
      end
    end

    private

    def upload
      Upload.new(request.raw_post, request.headers['Content-Range'], request.headers['X-Upload-Uuid'])
    end
  end
end
