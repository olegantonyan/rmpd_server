class Deviceapi::Protocol::Outgoing::DeletePlaylist < Deviceapi::Protocol::Outgoing::BaseCommand
  def call(options = {})
    clean_previous_commands
    enqueue(json)
  end

  def json
    {'type' => 'playlist', 'status' => 'delete'}
  end

end
