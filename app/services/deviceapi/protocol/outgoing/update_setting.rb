class Deviceapi::Protocol::Outgoing::UpdateSetting < Deviceapi::Protocol::Outgoing::BaseCommand
  # rubocop: disable Lint/UnusedMethodArgument
  def call(options = {})
    return unless device
    clean_previous_commands
    enqueue(json)
  end
  # rubocop: enable Lint/UnusedMethodArgument

  private

  def json
    {
      time_zone: device.time_zone_formatted_offset
    }
  end
end
