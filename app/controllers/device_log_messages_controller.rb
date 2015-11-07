class DeviceLogMessagesController < BaseController
  def index
    @device_log_messages = policy_scope Device::LogMessage.where(device_id: params[:device_id]).order(created_at: :desc).paginate(page: params[:page], per_page: 100)
    authorize @device_log_messages
  end
end
