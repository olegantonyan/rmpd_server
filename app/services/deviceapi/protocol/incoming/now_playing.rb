module Deviceapi
  module Protocol
    module Incoming
      class NowPlaying < Deviceapi::Protocol::Incoming::BaseCommand
        def call(_options = {})
          device.device_status.now_playing = data[:message]
        end
      end
    end
  end
end
