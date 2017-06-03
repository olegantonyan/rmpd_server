module Deviceapi
  module Protocol
    module Incoming
      class BaseAck < Deviceapi::Protocol::Incoming::BaseCommand
        def call(_options = {})
          outgoing_command_type = mq.message_type_for_sequence_number(sequence_number)
          Deviceapi::Util.outgoing_command_object(outgoing_command_type, device).ack(ok, sequence_number, data) if outgoing_command_type
        end
      end
    end
  end
end
