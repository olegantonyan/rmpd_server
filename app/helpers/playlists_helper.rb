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

  def media_item_begin_date(playlist, item)
    find_media_item(playlist, item).try(:begin_date) || Date.current
  end

  def media_item_end_date(playlist, item)
    find_media_item(playlist, item).try(:end_date) || Date.current + 1.month
  end

  def media_items_advertising_playbacks_per_days(playlist, item)
    find_media_item(playlist, item).try(:playbacks_per_day).to_i
  end

  def media_items_background_begin_time playlist
    playlist.playlist_items.background.first.try(:begin_time) || Time.parse('09:00')
  end

  def media_items_background_end_time playlist
    playlist.playlist_items.background.first.try(:end_time) || Time.parse('18:00')
  end

  private

  def find_media_item(playlist, item)
    playlist.playlist_items.find_by(media_item_id: item.id)
  end

end
