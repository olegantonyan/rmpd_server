module Deviceapi::Sender
  def send_to(command, options = {})
    send_to_device(command, self, options)
  end

  def send_to_device(command, device, options = {})
    Deviceapi::Util.outgoing_command_object(command, device).call(options)
  end
end
