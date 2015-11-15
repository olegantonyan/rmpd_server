class Deviceapi::Protocol::Outgoing::BaseCommand
  attr_reader :device, :mq

  def initialize(device)
    @device = device
    @mq = Deviceapi::MessageQueue
  end

  protected

  def enqueue(json)
    mq.enqueue(device.login, json.merge({'command' => type}).to_json, type)
  end

  def clean_previous_commands
    mq.destroy_messages_with_type(device.login, type)
  end

  def type
    @_type ||= self.class.name.underscore.split('/').last
  end
end
