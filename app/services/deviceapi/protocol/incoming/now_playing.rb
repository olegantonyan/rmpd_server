class Deviceapi::Protocol::Incoming::NowPlaying < Deviceapi::Protocol::Incoming::BaseCommand
  # rubocop: disable Lint/UnusedMethodArgument
  def call(options = {})
    device.device_status.now_playing = data[:message]
  end
  # rubocop: enable Lint/UnusedMethodArgument
end
