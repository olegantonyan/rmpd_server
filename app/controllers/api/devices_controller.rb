class Api::DevicesController < Api::BaseJsonapiController
  def base_meta
    devices = Pundit.policy_scope(current_user, Device.all)
    super.merge(total_devices: devices.count, online_devices: devices.online.count)
  end
end
