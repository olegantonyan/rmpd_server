module PlaylistsHelper
  def has_media_item?(playlist, item)
    playlist.media_items.find_by_id(item.id)
  end

  def media_item_position(playlist, item)
    find_media_item(playlist, item).try(:position).to_i
  end

  def media_item_begin_time(playlist, item)
    find_media_item(playlist, item).try(:begin_time) || Time.parse('09:00')
  end

  def media_item_end_time(playlist, item)
    find_media_item(playlist, item).try(:end_time) || Time.parse('18:00')
  end

  def media_item_playbacks_total(playlist, item)
    find_media_item(playlist, item).try(:playbacks_total).to_i
  end

  private

  def find_media_item(playlist, item)
    playlist.playlist_items.find_by(media_item_id: item.id)
  end

end
