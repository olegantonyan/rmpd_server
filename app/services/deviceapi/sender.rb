module Deviceapi
  class Sender
    using Typerb

    attr_reader :device

    def initialize(device)
      @device = device.type!(Device)
    end

    def send(command, options = {})
      Deviceapi::Util.outgoing_command_object(command, device).call(options)
    end
  end
end
