class Deviceapi::Protocol::Incoming::PowerOn < Deviceapi::Protocol::Incoming::BaseCommand
  # rubocop: disable Lint/UnusedMethodArgument
  def call(options = {})
    device.device_status.poweredon_at = Time.current
    mq.reenqueue_all(device.login)
  end
  # rubocop: enable Lint/UnusedMethodArgument
end
