class Deviceapi::Protocol::Incoming::Legacy::Power < Deviceapi::Protocol::Incoming::BaseCommand
  def call(options = {})
    if data[:status] == 'on'
      Deviceapi::Protocol::Incoming::PowerOn.new(device, data, sequence_number).call
    end
  end
end
