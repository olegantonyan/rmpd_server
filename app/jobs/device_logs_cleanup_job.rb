class DeviceLogsCleanupJob < ApplicationJob
  def perform
    Device.joins(:device_log_messages).group('devices.id').having('count(device_log_messages.id) > 10000').find_each do |device|
      device.device_log_messages.where('created_at < ?', Time.current - 6.months).delete_all
    end
  end
end
