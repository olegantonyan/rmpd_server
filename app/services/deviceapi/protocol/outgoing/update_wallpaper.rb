module Deviceapi
  module Protocol
    module Outgoing
      class UpdateWallpaper < Deviceapi::Protocol::Outgoing::BaseCommand
        def call(_options = {})
          return unless device
          clean_previous_commands
          enqueue(json)
        end

        private

        def json
          { url: device.wallpaper_url }
        end
      end
    end
  end
end
