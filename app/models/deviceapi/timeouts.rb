class Deviceapi::Timeouts
  def self.check
    devices = Device::Status.where("online = ? AND updated_at <= ?", true, Time.now - 60)
    count = devices.size
    if count > 0
      devices.update_all(:online => false, :now_playing => "")
      Rails.logger.info("#{count.to_s} gone offline")
    end
  end
end
