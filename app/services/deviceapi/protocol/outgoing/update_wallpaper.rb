class Deviceapi::Protocol::Outgoing::UpdateWallpaper < Deviceapi::Protocol::Outgoing::BaseCommand
  def call(_options = {})
    return unless device
    clean_previous_commands
    enqueue(json)
  end

  private

  def json
    { url: device.wallpaper_url }
  end
end
