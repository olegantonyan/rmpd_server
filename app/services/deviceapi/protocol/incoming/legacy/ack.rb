module Deviceapi
  module Protocol
    module Incoming
      module Legacy
        class Ack < Deviceapi::Protocol::Incoming::BaseCommand
          def call(_options = {})
            if data[:status] == 'ok'
              Deviceapi::Protocol::Incoming::AckOk
            else
              Deviceapi::Protocol::Incoming::AckFail
            end.new(device, data, sequence_number).call
          end
        end
      end
    end
  end
end
