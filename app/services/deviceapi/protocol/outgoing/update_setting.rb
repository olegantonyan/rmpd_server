class Deviceapi::Protocol::Outgoing::UpdateSetting < Deviceapi::Protocol::Outgoing::BaseCommand
  def call(*options)
    return unless device
    clean_previous_commands
    enqueue(json(*options))
  end

  private

  def json(*options)
    result = {}
    result[:time_zone] = device.time_zone_formatted_offset if options.include?(:time_zone)
    result
  end
end
