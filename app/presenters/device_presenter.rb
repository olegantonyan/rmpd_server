class DevicePresenter < BasePresenter
  def time_zone_info
    "#{model.time_zone} (#{model.time_zone_formatted_offset})"
  end
end
