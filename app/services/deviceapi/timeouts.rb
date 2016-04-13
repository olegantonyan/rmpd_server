class Deviceapi::Timeouts
  # rubocop: disable Metrics/MethodLength
  def self.check
    old_logger = ActiveRecord::Base.logger

    ActiveRecord::Base.logger = nil
    statuses = Device::Status.where('online = ? AND updated_at <= ?', true, Time.current - 60)
    if statuses.exists?
      ActiveRecord::Base.logger = old_logger

      new_online_status = false
      statuses.find_each do |status|
        Rails.logger&.info("#{status.device} gone offline")
        Notifiers::DeviceStatusNotifierJob.perform_later(status.device, new_online_status, Time.current.to_s)
      end
      statuses.update_all(online: new_online_status, now_playing: '')
    end

  ensure
    ActiveRecord::Base.logger = old_logger
  end
end
