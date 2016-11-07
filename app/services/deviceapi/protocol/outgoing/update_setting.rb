class Deviceapi::Protocol::Outgoing::UpdateSetting < Deviceapi::Protocol::Outgoing::BaseCommand
  def call(options = {})
    return unless device
    clean_previous_commands
    enqueue(json(options))
  end

  private

  def json(options = {})
    {}.tap do |j|
      attrs = options.fetch(:changed_attrs, [])
      if attrs.include?(:time_zone)
        j[:time_zone] = device.time_zone_formatted_offset
        j[:time_zone_name] = device.time_zone
      end
      if attrs.include?(:message_queue_sync_period)
        j[:message_queue_sync_period] = device.message_queue_sync_period
      end
    end
  end
end
