class Deviceapi::Protocol::Incoming::NowPlaying < Deviceapi::Protocol::Incoming::BaseCommand
  include Deviceapi::Sender

  def call(options = {})
    device.device_status.now_playing = data[:message]
    if %w(none nothing).include? data[:message]
      send_to_device(:update_playlist, device)
    end
  end
end
