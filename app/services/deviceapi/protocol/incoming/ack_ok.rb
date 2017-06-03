module Deviceapi
  module Protocol
    module Incoming
      class AckOk < Deviceapi::Protocol::Incoming::BaseAck
        def ok
          true
        end
      end
    end
  end
end
