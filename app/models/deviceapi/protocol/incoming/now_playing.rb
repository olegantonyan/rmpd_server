class Deviceapi::Protocol::Incoming::NowPlaying < Deviceapi::Protocol::Incoming::BaseCommand
  def call(options = {})
    device.device_status.now_playing = data[:message]
  end
end