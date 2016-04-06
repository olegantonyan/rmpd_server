class DevicePresenter < BasePresenter
  def time_zone
    "#{model.time_zone} (#{model.time_zone_formatted_offset})"
  end

  def device_groups
    h.collection_links(super, :title, :device_group_path)
  end

  def playlist
    return '' unless super
    text = if synchronizing?
             "#{h.sanitize(super.to_s)} #{h.icon('refresh')}".html_safe
           else
             super.to_s
           end
    h.link_to(text, h.playlist_path(super)).html_safe
  end
end
