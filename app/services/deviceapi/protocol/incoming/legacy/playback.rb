module Deviceapi
  module Protocol
    module Incoming
      module Legacy
        class Playback < Deviceapi::Protocol::Incoming::BaseCommand
          def call(_options = {})
            Deviceapi::Protocol::Incoming::NowPlaying.new(device, data.merge(message: data[:track]), sequence_number).call if data[:status] == 'now_playing'
          end
        end
      end
    end
  end
end
