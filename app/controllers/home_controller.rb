class HomeController < UsersApplicationController
  def index
    d = DeviceStatus.online
    @online_devices_count = d == nil ? 0 : d.count
  end
end
