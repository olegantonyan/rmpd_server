module Deviceapi
  module Protocol
    module Outgoing
      class DeleteAllFile < Deviceapi::Protocol::Outgoing::BaseCommand
        def call(_options = {})
          clean_previous_commands
          enqueue
        end
      end
    end
  end
end
