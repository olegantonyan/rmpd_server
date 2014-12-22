class DeviceLogsController < UsersApplicationController
  def index
    @device = Device.find(params[:device_id])
  end
  
  def show
  end
end
