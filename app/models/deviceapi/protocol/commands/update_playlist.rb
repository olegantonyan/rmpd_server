class Deviceapi::Protocol::Commands::UpdatePlaylist < Deviceapi::Protocol::BaseCommand
  def call(to_device, options = {})
    if to_device.playlist
      items = []
      to_device.playlist.playlist_items.includes(:media_item).each {|d| items << d.media_item.file_url }
      #to_device.playlist.media_items.each {|i| items << i.file_url } #TODO fix this fucking problem
      p = Playlist.find(to_device.playlist.id) #note: http://stackoverflow.com/questions/26923249/rails-carrierwave-manual-file-upload-wrong-url
      items << p.file_url

      clean_previous_commands(to_device.login, type)
      Deviceapi::MessageQueue.enqueue(to_device.login, json(items), type)
    end
  end

  def json(items)
    {'type' => 'playlist', 'status' => 'update', 'items' => items}.to_json
  end

end
