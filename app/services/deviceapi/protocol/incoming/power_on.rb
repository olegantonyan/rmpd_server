class Deviceapi::Protocol::Incoming::PowerOn < Deviceapi::Protocol::Incoming::BaseCommand
  def call(_options = {})
    device.device_status.poweredon_at = Time.current
    mq.reenqueue_all(device.login, Deviceapi::Util.reenquable_on_poweron_commands)
  end
end
