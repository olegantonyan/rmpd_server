module Deviceapi
  module Protocol
    module Incoming
      class NowPlaying < Deviceapi::Protocol::Incoming::BaseCommand
        def call(_options = {})
          device.update(now_playing: data[:message])
        end
      end
    end
  end
end
