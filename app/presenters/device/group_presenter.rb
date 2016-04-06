class Device::GroupPresenter < BasePresenter
  def devices
    h.collection_links(super, :name, :device_path)
  end

  def selected_playlist_id
    plsids = model.devices.pluck(:playlist_id)
    return unless plsids.all? { |i| i == plsids.first }
    plsids.first
  end
end
