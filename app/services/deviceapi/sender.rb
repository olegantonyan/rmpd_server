module Deviceapi
  class Sender
    attr_reader :device

    def initialize(device)
      @device = device
    end

    def send(command, options = {})
      Deviceapi::Util.outgoing_command_object(command, device).call(options)
    end
  end
end
