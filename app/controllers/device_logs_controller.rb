class DeviceLogsController < UsersApplicationController
  
  def index
    @device_logs = DeviceLog.where(:device_id => params[:device_id]).order(:created_at => :desc).paginate(:page => params[:page], :per_page => 50).to_a
    @device = Device.find(params[:device_id])
  end

end
