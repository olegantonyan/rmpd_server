class Notifiers::PlaybackErrorNotifierJob < Notifiers::BaseNotifierJob
  def perform(device, playlist_item_id, filename, text)
    notify(text, icon_emoji: ':hurtrealbad:', attachments: attachments(device, playlist_item_id, filename, text))
  end

  private

  def attachments(device, playlist_item_id, text)
    playlist_item = Playlist::Item.find_by_id(playlist_item_id)
    [{
      fields: [{ title: 'Device login', value: device.login, short: false },
               { title: 'Playlist item', value: playlist_item ? playlist_item.to_s : "#{filename} (#{playlist_item_id} deleted)", short: false }],
      color: 'danger',
      fallback: text,
      text: text,
      author_name: device.to_s,
      author_link: playlist_item ? media_item_url(playlist_item.media_item) : device_url(device)
    }]
  end
end
