class Deviceapi::Protocol::Incoming::PlaybackError < Deviceapi::Protocol::Incoming::BaseCommand
  def call(_options = {})
    Notifiers::PlaybackErrorNotifierJob.perform_later(device, data['message']['id'], data['message']['filename'], data['message']['error_text'])
  end
end
