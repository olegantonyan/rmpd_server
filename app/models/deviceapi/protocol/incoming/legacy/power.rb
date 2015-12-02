class Deviceapi::Protocol::Incoming::Legacy::Power < Deviceapi::Protocol::Incoming::BaseCommand
  # rubocop: disable Lint/UnusedMethodArgument
  def call(options = {})
    Deviceapi::Protocol::Incoming::PowerOn.new(device, data, sequence_number).call if data[:status] == 'on'
  end
  # rubocop: enable Lint/UnusedMethodArgument
end
