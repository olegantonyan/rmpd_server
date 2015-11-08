class Deviceapi::Protocol::Incoming::Power < Deviceapi::Protocol::Incoming::BaseCommand
  def call(options = {})
    if data[:status] == 'on'
      device.device_status.poweredon_at = Time.zone.now
      mq.reenqueue_all(device.login)
    end
  end
end
