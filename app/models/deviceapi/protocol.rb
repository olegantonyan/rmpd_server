require 'time'

class Deviceapi::Protocol

  Deviceapi::Protocol::BaseCommand.available.each do |command|
    define_method("#{command}") do |to_device, options = {}|
      "#{self.class.name}::Commands::#{command.classify}".constantize.new.call(to_device, options)
    end
  end

  def process(from_device, data, user_agent, incomming_sequence_number)
    return if from_device.nil?

    if from_device.device_status.nil?
      from_device.device_status = Device::Status.new
    end

    from_device.device_status.online = true
    from_device.device_status.touch

    write_device_log(from_device, data, user_agent)

    case data["type"]
    when "ack"
      if data["status"] == "ok"
        Deviceapi::MessageQueue.remove(incomming_sequence_number)
      else
        if Deviceapi::MessageQueue.retries(incomming_sequence_number) < 15
          Deviceapi::MessageQueue.reenqueue(incomming_sequence_number)
        else
          Rails.logger.warn("Maximum retries reached for device '#{from_device.login}'")
          Deviceapi::MessageQueue.remove(incomming_sequence_number)
        end
      end
    when "power"
      if data["status"] == "on"
        from_device.device_status.poweredon_at = Time.now
        Deviceapi::MessageQueue.reenqueue_all(from_device.login)
      end
    when "playback"
      if data["status"] == "now_playing"
        from_device.device_status.now_playing = data["track"]
        from_device.device_status.devicetime = Time.parse(data["localtime"])
        if data["track"] == "none"
          update_playlist(from_device)
        elsif data["track"] == "updating_now"
          #nothing to do
        end
      end
    end

    from_device.device_status.save if from_device.device_status.new_record? or from_device.device_status.changed?

    Deviceapi::MessageQueue.dequeue(from_device.login)
  end

  private

  def write_device_log(device, logdata, user_agent)
    Device::LogMessage.write(device, logdata, user_agent)
  end

end
