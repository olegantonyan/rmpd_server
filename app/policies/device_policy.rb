class DevicePolicy
  attr_reader :current_user, :device
  
  def initialize(user, device)
    current_user = user
    device = device
  end
  
  
  
end