class Deviceapi::Protocol::Incoming::PowerOn < Deviceapi::Protocol::Incoming::BaseCommand
  def call(options = {})
    device.device_status.poweredon_at = Time.current
    mq.reenqueue_all(device.login)
  end
end
