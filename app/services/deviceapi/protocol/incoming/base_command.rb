module Deviceapi
  module Protocol
    module Incoming
      class BaseCommand
        attr_reader :device, :data, :sequence_number, :mq

        def initialize(device, data, sequence_number)
          @device = device
          @data = data
          @sequence_number = sequence_number
          @mq = Deviceapi::MessageQueue
        end
      end
    end
  end
end
