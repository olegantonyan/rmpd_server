class Deviceapi::Protocol::Outgoing::DeletePlaylist < Deviceapi::Protocol::Outgoing::BaseCommand
  def call(options = {})
    clean_previous_commands
    enqueue(json)
  end

  private

  def json
    legacy_json
  end

  def legacy_json
    {type: 'playlist', status: 'delete'}
  end

end
