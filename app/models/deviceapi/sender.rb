module Deviceapi::Sender
  def send_to(command, options = {})
    send_to_device(command, self, options)
  end

  def send_to_device(command, device, options = {})
    command_object(command, device).call(options)
  end

  private

  def command_object(command, device)
    "Deviceapi::Protocol::Outgoing::#{command.to_s.classify}".constantize.new(device)
  end
end
