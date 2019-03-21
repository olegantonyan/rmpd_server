module Deviceapi
  module Protocol
    module Outgoing
      class BaseCommand
        attr_reader :device, :mq

        def initialize(device)
          @device = device
          @mq = Deviceapi::MessageQueue
        end

        def ack(ok, sequence_number, _data = {})
          if ok
            mq.remove(sequence_number)
          elsif mq.retries(sequence_number) < max_retries
            notify_error('retry command', sequence_number)
            mq.reenqueue(sequence_number)
          else
            notify_error("maximum retries of #{max_retries} reached", sequence_number)
            mq.remove(sequence_number)
          end
        end

        def max_retries
          15
        end

        def self.reenquable
          true
        end

        protected

        def enqueue(json = {})
          mq.enqueue(device.login, json.merge(command: type).to_json, type)
        end

        def clean_previous_commands
          mq.destroy_messages_with_type(device.login, type)
        end

        def type
          @type ||= self.class.name.underscore.split('/').last
        end

        def notify_error(msg, sequence_number)
          full_message = "#{msg} (device #{device}, sequence_number #{sequence_number}, command_type #{type}))"
          Rails.logger.error full_message
          Notifiers::ErrorNotifierJob.perform_later(device, full_message)
        end
      end
    end
  end
end
