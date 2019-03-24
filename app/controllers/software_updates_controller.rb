class SoftwareUpdatesController < ApplicationController
  def self.controller_path
    'devices/software_update'
  end

  def index
    device = Device.find(params[:device_id])
    @software_updates = device.device_software_updates.ordered
    @software_update = device.device_software_updates.build
    authorize(@software_update)
  end

  def create # rubocop: disable Metrics/AbcSize, Metrics/MethodLength
    @software_update = Device::SoftwareUpdate.new(software_update_params)
    device = Device.find(params[:device_id])
    @software_update.device = device
    authorize(@software_update)

    if @software_update.save
      Deviceapi::Sender.new(device).send(:update_software, distribution_url: @software_update.file_url)
      flash[:notice] = "#{device} will be updated soon"
      redirect_to(device_path(device))
    else
      @software_updates = device.device_software_updates.ordered
      flash[:alert] = 'Error requesting device software update'
      render(:index)
    end
  end

  private

  def set_device
    @device = Device.find(params[:device_id])
  end

  def software_update_params
    params.require(:device_software_update).permit(:version, :file)
  end
end
