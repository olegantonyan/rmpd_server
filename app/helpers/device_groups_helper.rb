module DeviceGroupsHelper
  def selected_playlist_id(group)
    plsids = group.devices.pluck(:playlist_id)
    if plsids.all?{|i| i == plsids.first}
      plsids.first
    else
      nil
    end
  end
end
