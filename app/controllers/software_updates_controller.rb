class SoftwareUpdatesController < ApplicationController
  skip_before_action :authenticate_user!, only: :download # TODO: authorize device maybe?

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
      Deviceapi::Sender.new(device).send(:update_software, distribution_url: device_software_update_download_url(@software_update.device, @software_update.id))
      flash[:notice] = "#{device} will be updated soon"
      redirect_to(device_path(device))
    else
      @software_updates = device.device_software_updates.ordered
      flash[:alert] = @software_update.errors.full_messages.to_sentence
      render(:index)
    end
  end

  def download
    software_update = Device.find(params[:device_id]).device_software_updates.find(params[:software_update_id])
    file = Tempfile.new
    file.binmode
    file.write(software_update.file)
    send_file(file.path)
  end

  private

  def software_update_params
    params.require(:device_software_update).permit(:version, :file)
  end
end
