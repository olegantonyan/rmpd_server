module Deviceapi::Receiver
  def received_from_device(device, data, user_agent, sequence_number)
    prepare_update_device_status(device, data)
    write_device_log(device, data, user_agent)
    command_object(device, data).call(sequence_number: sequence_number)
    save_device_status(device)
    Deviceapi::MessageQueue.dequeue(device.login)
  end

  private

  def command_object(device, data)
    "Deviceapi::Protocol::Incoming::#{data[:type].to_s.classify}".constantize.new(device, data)
  end

  def prepare_update_device_status(device, data)
    device.build_device_status unless device.device_status
    device.device_status.devicetime = Time.parse(data[:localtime]) if data[:localtime]
    device.device_status.online = true
    device.device_status.updated_at = Time.zone.now
  end

  def save_device_status(device)
    device.device_status.save
  end

  def write_device_log(device, logdata, user_agent)
    Device::LogMessage.write(device, logdata, user_agent)
  end

end
