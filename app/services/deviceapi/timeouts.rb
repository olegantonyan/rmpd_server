module Deviceapi
  class Timeouts
    def call
      devices = Device.where('online = ? AND updated_at <= ?', true, Time.current - 60)
      return unless devices.exists?
      new_online_status = false
      devices.find_each do |device|
        Rails.logger&.info("#{device} gone offline")
        Notifiers::DeviceStatusNotifierJob.perform_later(device, new_online_status, Time.current.to_s)
      end
      devices.update_all(online: new_online_status, now_playing: '') # rubocop: disable Rails/SkipsModelValidations
    end
  end
end
