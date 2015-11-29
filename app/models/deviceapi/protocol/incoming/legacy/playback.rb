class Deviceapi::Protocol::Incoming::Legacy::Playback < Deviceapi::Protocol::Incoming::BaseCommand
  def call(options = {})
    if data[:status] == 'now_playing'
      Deviceapi::Protocol::Incoming::NowPlaying.new(device, data, sequence_number).call
    end
  end
end
