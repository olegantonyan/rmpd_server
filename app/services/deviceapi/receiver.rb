module Deviceapi
  class Receiver
    attr_reader :device

    def initialize(device)
      @device = device
    end

    def receive(data, user_agent, sequence_number)
      prepare_update_device_status(data)
      notify_status
      save_device_status # prevent possible duplication of notification. in case of fast events received and multithereaded server
      write_device_log(data, user_agent)
      Deviceapi::Util.incomming_command_object(device, data, sequence_number).call
      save_device_status
    end

    def dequeue
      Deviceapi::MessageQueue.dequeue(device.login)
    end

    private

    def prepare_update_device_status(data) # rubocop: disable Metrics/AbcSize
      device.build_device_status unless device.device_status
      device.device_status.devicetime = Time.zone.parse(data[:localtime]) if data[:localtime]
      device.device_status.online = true
      device.device_status.updated_at = Time.current
      device.device_status.free_space = data[:free_space] if data[:free_space]
    end

    def save_device_status
      device.device_status.save if device.device_status.changed?
    end

    def write_device_log(logdata, user_agent)
      return if [logdata[:status], logdata[:command]].any? { |i| i == 'now_playing' }
      logdata.permit!
      Device::LogMessage.write!(device, logdata, user_agent)
    rescue StandardError => e
      logger.error("error writing device log: #{e.message}")
    end

    def notify_status
      Notifiers::DeviceStatusNotifierJob.perform_later(device, device.device_status.online, Time.current.to_s) if device.device_status.online_changed?
    end
  end
end
