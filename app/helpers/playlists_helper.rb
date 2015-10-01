module PlaylistsHelper
  def has_media_item?(playlist, item)
    playlist.media_items.find_by_id(item.id)
  end

  def media_item_position(playlist, item)
    playlist.playlist_items.find_by(media_item_id: item.id).try(:position).to_i
  end
end
