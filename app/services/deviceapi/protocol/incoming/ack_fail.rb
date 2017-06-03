module Deviceapi
  module Protocol
    module Incoming
      class AckFail < Deviceapi::Protocol::Incoming::BaseAck
        def ok
          false
        end
      end
    end
  end
end
