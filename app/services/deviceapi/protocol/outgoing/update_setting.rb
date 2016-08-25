class Deviceapi::Protocol::Outgoing::UpdateSetting < Deviceapi::Protocol::Outgoing::BaseCommand
  def call(options = {})
    return unless device
    clean_previous_commands
    enqueue(json(options))
  end

  private

  def json(options = {})
    {}.tap do |j|
      if options.fetch(:changed_attrs, []).include?(:time_zone)
        j[:time_zone] = device.time_zone_formatted_offset
        j[:time_zone_name] = device.time_zone
      end
    end
  end
end
