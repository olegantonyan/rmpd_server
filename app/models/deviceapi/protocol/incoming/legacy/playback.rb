class Deviceapi::Protocol::Incoming::Legacy::Playback < Deviceapi::Protocol::Incoming::BaseCommand
  # rubocop: disable Lint/UnusedMethodArgument
  def call(options = {})
    Deviceapi::Protocol::Incoming::NowPlaying.new(device, data.merge(message: data[:track]), sequence_number).call if data[:status] == 'now_playing'
  end
  # rubocop: enable Lint/UnusedMethodArgument
end
