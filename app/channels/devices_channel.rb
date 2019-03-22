class DevicesChannel < ApplicationCable::Channel
  def subscribed
    device = Device.find_by(id: params[:device_id])
    if device && DevicePolicy.new(current_user, device).show?
      stream_for(device)
    else
      reject
    end
  end

  def unsubscribed
  end
end
