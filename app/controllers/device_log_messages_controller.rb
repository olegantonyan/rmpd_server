class DeviceLogMessagesController < BaseController
  
  def index
    @device_log_messages = Device::LogMessage.where(:device_id => params[:device_id]).order(:created_at => :desc).paginate(:page => params[:page], :per_page => 50).to_a
    @device = Device.find(params[:device_id])
  end

end
