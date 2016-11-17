class Api::UploadsController < Api::BaseController
  include Api::Concerns::Uploadable

  def create
    u = upload
    if u.save
      render json: { uuid: u.uuid }
    else
      render json: { error: 'error uploading file' }, status: 422
    end
  end
end
