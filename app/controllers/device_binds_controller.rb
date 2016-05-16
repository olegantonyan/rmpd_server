class DeviceBindsController < BaseController
  def new
    @device_bind = Device::Bind.new
    authorize @device_bind
  end

  def create
    @device_bind = Device::Bind.new(device_bind_params)
    authorize @device_bind
    crud_respond @device_bind, success_url: devices_path
  end

  private

  def device_bind_params
    params.require(:device_bind).permit(:login, :company_id, :name, :time_zone, device_group_ids: [])
  end
end
