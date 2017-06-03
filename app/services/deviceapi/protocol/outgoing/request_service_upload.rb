module Deviceapi
  module Protocol
    module Outgoing
      class RequestServiceUpload < Deviceapi::Protocol::Outgoing::BaseCommand
        def call(_options = {})
          clean_previous_commands
          enqueue(json)
        end

        private

        def json
          {}
        end
      end
    end
  end
end
