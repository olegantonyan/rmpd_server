class Deviceapi::Protocol::Incoming::Ack < Deviceapi::Protocol::Incoming::BaseCommand
  def call(device, data, options = {})
    sequence_number = options.fetch(:sequence_number)
    if data[:status] == 'ok'
      Deviceapi::MessageQueue.remove(sequence_number)
    else
      if Deviceapi::MessageQueue.retries(sequence_number) < 15
        Deviceapi::MessageQueue.reenqueue(sequence_number)
      else
        Rails.logger.warn("Maximum retries reached for device '#{device.login}'")
        Deviceapi::MessageQueue.remove(sequence_number)
      end
    end
  end
end
