module Deviceapi
  module Protocol
    module Outgoing
      class UpdateSoftware < Deviceapi::Protocol::Outgoing::BaseCommand
        def call(options = {})
          return unless device
          clean_previous_commands
          enqueue(json(options[:distribution_url]))
        end

        def ack(ok, sequence_number, data = {})
          super
          Notifiers::SoftwareUpdateNotifierJob.perform_later(device, ok, data[:message])
        end

        def max_retries
          0
        end

        def self.reenquable
          false
        end

        private

        def json(url)
          { distribution_url: url }
        end
      end
    end
  end
end
