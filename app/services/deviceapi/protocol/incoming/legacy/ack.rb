class Deviceapi::Protocol::Incoming::Legacy::Ack < Deviceapi::Protocol::Incoming::BaseCommand
  # rubocop: disable Lint/UnusedMethodArgument
  def call(options = {})
    if data[:status] == 'ok'
      Deviceapi::Protocol::Incoming::AckOk
    else
      Deviceapi::Protocol::Incoming::AckFail
    end.new(device, data, sequence_number).call
  end
  # rubocop: enable Lint/UnusedMethodArgument
end
