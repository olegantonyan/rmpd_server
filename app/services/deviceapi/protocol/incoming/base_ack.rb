class Deviceapi::Protocol::Incoming::BaseAck < Deviceapi::Protocol::Incoming::BaseCommand
  include Deviceapi::Sender

  def call(_options = {})
    outgoing_command_type = mq.message_type_for_sequence_number(sequence_number)
    outgoing_command_object(outgoing_command_type, device).ack(ok, sequence_number, data) if outgoing_command_type
  end
end
