class Deviceapi::Protocol::Outgoing::ClearQueue < Deviceapi::Protocol::Outgoing::BaseCommand
  def call(options = {})
    mq.destroy_all_messages device.login
  end
end
