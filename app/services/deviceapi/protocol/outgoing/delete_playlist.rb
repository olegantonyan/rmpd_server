module Deviceapi
  module Protocol
    module Outgoing
      class DeletePlaylist < Deviceapi::Protocol::Outgoing::BaseCommand
        def call(_options = {})
          clean_previous_commands
          enqueue(json)
        end

        private

        def json
          legacy_json
        end

        def legacy_json
          { type: 'playlist', status: 'delete' }
        end
      end
    end
  end
end
