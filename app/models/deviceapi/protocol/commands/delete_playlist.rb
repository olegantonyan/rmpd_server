class Deviceapi::Protocol::Commands::DeletePlaylist < Deviceapi::Protocol::BaseCommand
  def call(to_device, options = {})
    clean_previous_commands(to_device.login, type)
    Deviceapi::MessageQueue.enqueue(to_device.login, json, type)
  end

  def json
    {'type' => 'playlist', 'status' => 'delete'}.to_json
  end

end
