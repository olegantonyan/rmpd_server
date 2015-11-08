class Deviceapi::Protocol::Outgoing::ClearQueue < Deviceapi::Protocol::Outgoing::BaseCommand
  def call(for_device, options = {})
    Deviceapi::MessageQueue.destroy_all_messages for_device.login
  end
end
