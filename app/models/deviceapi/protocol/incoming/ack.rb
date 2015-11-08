class Deviceapi::Protocol::Incoming::Ack < Deviceapi::Protocol::Incoming::BaseCommand
  def call(device, data, options = {})
    sequence_number = options.fetch(:sequence_number)
    mq = Deviceapi::MessageQueue
    if data[:status] == 'ok'
      mq.remove(sequence_number)
    else
      if mq.retries(sequence_number) < 15
        mq.reenqueue(sequence_number)
      else
        Rails.logger.warn("Maximum retries reached for device '#{device.login}'")
        mq.remove(sequence_number)
      end
    end
  end
end
