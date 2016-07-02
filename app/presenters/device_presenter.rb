class DevicePresenter < BasePresenter
  def time_zone
    "#{model.time_zone} (#{model.time_zone_formatted_offset})"
  end

  def device_groups
    h.collection_links(super, :title, :device_group_path)
  end

  def name
    if synchronizing?
      "#{h.sanitize(super.to_s)} #{h.icon('refresh')}".html_safe
    else
      super.to_s
    end
  end

  def playlist
    h.link_to(super.to_s, h.safe_path_to(:playlist_path, super))
  end

  def company
    h.link_to(super.to_s, h.safe_path_to(:company_path, super))
  end

  def wallpaper
    if super.present?
      h.link_to(h.image_tag(super.thumb.url, size: '100x100', class: 'img img-thumbnail'), wallpaper_url)
    else
      ''
    end
  end
end
