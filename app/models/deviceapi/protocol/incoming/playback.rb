class Deviceapi::Protocol::Incoming::Playback < Deviceapi::Protocol::Incoming::BaseCommand
  include Deviceapi::Sender

  def call(device, data, options = {})
    if data[:status] == 'now_playing'
      device.device_status.now_playing = data[:track]
      if data[:track] == 'none'
        send_to_device(:update_playlist, device)
      elsif data[:track] == 'updating_now'
        #nothing to do
      end
    end
  end
end
