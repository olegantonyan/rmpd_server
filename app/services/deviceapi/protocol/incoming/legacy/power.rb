module Deviceapi
  module Protocol
    module Incoming
      module Legacy
        class Power < Deviceapi::Protocol::Incoming::BaseCommand
          def call(_options = {})
            Deviceapi::Protocol::Incoming::PowerOn.new(device, data, sequence_number).call if data[:status] == 'on'
          end
        end
      end
    end
  end
end
