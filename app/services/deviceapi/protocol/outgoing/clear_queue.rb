module Deviceapi
  module Protocol
    module Outgoing
      class ClearQueue < Deviceapi::Protocol::Outgoing::BaseCommand
        def call(_options = {})
          mq.destroy_all_messages(device.login)
        end
      end
    end
  end
end
