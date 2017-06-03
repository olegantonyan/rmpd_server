module Deviceapi
  class Util
    class << self
      def outgoing_command_object(command, device)
        outgoing_command_class(command).new(device)
      end

      def outgoing_command_class(command)
        "Deviceapi::Protocol::Outgoing::#{command.to_s.classify}".constantize
      end

      def incomming_command_object(device, data, sequence_number)
        if data[:command]
          "Deviceapi::Protocol::Incoming::#{data[:command].to_s.classify}"
        else
          "Deviceapi::Protocol::Incoming::Legacy::#{data[:type].to_s.classify}"
        end.constantize.new(device, data, sequence_number)
      end

      def available_commands
        Dir["#{File.dirname(__FILE__)}/protocol/outgoing/*.rb"].map { |f| File.basename(f, '.rb').to_sym }
      end

      def reenquable_on_poweron_commands
        available_commands.select do |command_name|
          command_class = outgoing_command_class(command_name)
          command_class.respond_to?(:reenquable) && command_class.public_send(:reenquable)
        end
      end
    end
  end
end
