class Deviceapi::Timeouts
  def self.check
    statuses = Device::Status.where('online = ? AND updated_at <= ?', true, Time.current - 60)
    if statuses.any?
      new_online_status = false
      statuses.find_each do |status|
        Rails.logger.info("#{status.device} gone offline")
        Notifiers::DeviceStatusNotifierJob.perform_later(status.device, new_online_status)
      end
      statuses.update_all(online: new_online_status, now_playing: '')
    end
  end
end
