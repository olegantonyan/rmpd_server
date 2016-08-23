class DeviceServiceUploadsController < BaseController
  include Filterrificable

  before_action :set_device

  def self.controller_path
    'devices/service_upload'
  end

  def index
    @service_uploads = policy_scope(@device.device_service_uploads).page(page).per_page(per_page)
    authorize @service_uploads
    @new_service_upload = build_service_upload
  end

  def manual_request
    srv = build_service_upload
    authorize srv
    if srv.request
      flash[:notice] = 'Service upload requested'
    else
      flash[:alert] = 'Error requesting service upload'
    end
    redirect_to @device
  end

  private

  def set_device
    @device = Device.find(params[:device_id])
  end

  def build_service_upload
    @device.device_service_uploads.build
  end
end
