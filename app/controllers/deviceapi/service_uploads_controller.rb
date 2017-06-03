module Deviceapi
  class ServiceUploadsController < Deviceapi::BaseController
    def create
      srv = device.device_service_uploads.build(service_upload_params)
      if srv.save
        head :ok
      else
        head :unprocessable_entity
      end
    end

    private

    def service_upload_params
      params.permit(:file, :reason)
    end
  end
end
