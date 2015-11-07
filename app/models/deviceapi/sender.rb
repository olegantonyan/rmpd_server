module Deviceapi::Sender
  def send_to(command, options = {})
    send_to_device(command, self, options)
  end

  def send_to_device(command, device, options = {})
    command_object_by_command(command).call(device, options)
  end

  private

  def command_object_by_command command
    "Deviceapi::Protocol::Commands::#{command.to_s.classify}".constantize.new
  end
end
