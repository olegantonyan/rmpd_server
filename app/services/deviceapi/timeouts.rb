module Deviceapi
  class Timeouts
    def call
      statuses = Device::Status.where('online = ? AND updated_at <= ?', true, Time.current - 60)
      return unless statuses.exists?
      new_online_status = false
      statuses.find_each do |status|
        Rails.logger&.info("#{status.device} gone offline")
        Notifiers::DeviceStatusNotifierJob.perform_later(status.device, new_online_status, Time.current.to_s)
      end
      statuses.update_all(online: new_online_status, now_playing: '') # rubocop: disable Rails/SkipsModelValidations
    end
  end
end
