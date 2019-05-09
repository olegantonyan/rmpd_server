module Deviceapi
  class Receiver
    using Typerb

    attr_reader :device

    def initialize(device)
      @device = device.type!(Device)
    end

    def receive(data, user_agent, sequence_number)
      update_device_status(data)
      write_device_log(data, user_agent)
      Deviceapi::Util.incomming_command_object(device, data, sequence_number).call
    end

    def dequeue
      Deviceapi::MessageQueue.dequeue(device.login)
    end

    private

    def update_device_status(data) # rubocop: disable Metrics/AbcSize
      device.devicetime = Time.zone.parse(data[:localtime]) if data[:localtime]
      device.online = true
      device.free_space = data[:free_space] if data[:free_space]
      device.ip_addr = data[:ip_addr] if data[:ip_addr]
      notify_status
      device.save if device.changed?
    end

    def write_device_log(logdata, user_agent)
      return if [logdata[:status], logdata[:command]].any? { |i| i == 'now_playing' }
      logdata.permit!
      Device::LogMessage.write!(device, logdata, user_agent)
    rescue StandardError => e
      Rails.logger.error("error writing device log: #{e.message}")
    end

    def notify_status
      Notifiers::DeviceStatusNotifierJob.perform_later(device, device.online, Time.current.to_s) if device.online_changed?
    end
  end
end
