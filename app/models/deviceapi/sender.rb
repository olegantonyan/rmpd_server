module Deviceapi::Sender
  def send_to_device(command, device, options = {})
    Deviceapi::Protocol.new.public_send(command, device, options)
  end
end
