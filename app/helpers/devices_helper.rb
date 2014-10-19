module DevicesHelper
  def device_online?(device)
    device.device_status != nil && device.device_status.online
  end
  
end
