module Deviceapi
  module Protocol
    module Incoming
      class PowerOn < Deviceapi::Protocol::Incoming::BaseCommand
        def call(_options = {})
          device.update(poweredon_at: Time.current)
          mq.reenqueue_all(device.login, Deviceapi::Util.reenquable_on_poweron_commands)
        end
      end
    end
  end
end
