module Deviceapi::Receiver
  def receive_from_device(device, data, user_agent, sequence_number)
    prepare_update_device_status(device, data)
    write_device_log(device, data, user_agent)
    incomming_command_object(device, data, sequence_number).call
    save_device_status(device)
  end

  def dequeue_for_device(device)
    Deviceapi::MessageQueue.dequeue(device.login)
  end

  def dequeue
    dequeue_for_device(self)
  end

  def receive_from(data, user_agent, sequence_number)
    receive_from_device(self, data, user_agent, sequence_number)
  end

  private

  def incomming_command_object(device, data, sequence_number)
    "Deviceapi::Protocol::Incoming::#{data[:type].to_s.classify}".constantize.new(device, data, sequence_number)
  end

  def prepare_update_device_status(device, data)
    device.build_device_status unless device.device_status
    device.device_status.devicetime = Time.parse(data[:localtime]) if data[:localtime]
    device.device_status.online = true
    device.device_status.updated_at = Time.zone.now
    Notifiers::DeviceStatusNotifierJob.perform_later(device, device.device_status.online) if device.device_status.online_changed?
  end

  def save_device_status(device)
    device.device_status.save
  end

  def write_device_log(device, logdata, user_agent)
    Device::LogMessage.write(device, logdata, user_agent)
  end

end
