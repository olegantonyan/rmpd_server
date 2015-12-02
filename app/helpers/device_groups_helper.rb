module DeviceGroupsHelper
  def selected_playlist_id(group)
    plsids = group.devices.pluck(:playlist_id)
    return unless plsids.all? { |i| i == plsids.first }
    plsids.first
  end
end
