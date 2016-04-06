class DevicePresenter < BasePresenter
  def time_zone
    "#{model.time_zone} (#{model.time_zone_formatted_offset})"
  end

  def device_groups
    h.collection_links(super, :title, :device_group_path)
  end
end
