class Deviceapi::Protocol::Incoming::BaseCommand
  attr_reader :device, :data, :mq

  def initialize(device, data)
    @device = device
    @data = data
    @mq = Deviceapi::MessageQueue
  end
end
