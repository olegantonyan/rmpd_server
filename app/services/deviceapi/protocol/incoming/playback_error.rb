module Deviceapi
  module Protocol
    module Incoming
      class PlaybackError < Deviceapi::Protocol::Incoming::BaseCommand
        def call(_options = {})
          Notifiers::PlaybackErrorNotifierJob.perform_later(device, data['message']['id'], data['message']['filename'], data['message']['error_text'])
        end
      end
    end
  end
end
