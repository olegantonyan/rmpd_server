class SoftwareUpdatesController < BaseController
  before_action :set_device

  def self.controller_path
    'devices/software_update'
  end

  def new
    @software_update = Device::SoftwareUpdate.new(device: @device)
    authorize @software_update
  end

  def create
    @software_update = Device::SoftwareUpdate.new(software_update_params)
    @software_update.device = @device
    authorize @software_update
    if @software_update.save
      flash[:notice] = "#{@device} will be updated soon"
      redirect_to @device
    else
      flash[:alert] = 'Error requesting device software update'
      render :new
    end
  end

  private

  def set_device
    @device = Device.find(params[:device_id])
  end

  def software_update_params
    params.require(:device_software_update).permit(:distribution)
  end
end
