class HomeController < UsersApplicationController
  def index
    @online_devices = policy_scope(DeviceStatus).online.to_a
  end
end
