class Deviceapi::Protocol::Outgoing::UpdatePlaylist < Deviceapi::Protocol::Outgoing::BaseCommand
  def call(options = {})
    if device.playlist
      items = []
      device.playlist.playlist_items.includes(:media_item).each {|d| items << d.media_item.file_url }
      #device.playlist.media_items.each {|i| items << i.file_url } #TODO fix this fucking problem
      p = Playlist.find(device.playlist.id) #note: http://stackoverflow.com/questions/26923249/rails-carrierwave-manual-file-upload-wrong-url
      items << p.file_url

      clean_previous_commands
      enqueue(json(items))
    end
  end

  def json(items)
    {'type' => 'playlist', 'status' => 'update', 'items' => items}.to_json
  end

end
