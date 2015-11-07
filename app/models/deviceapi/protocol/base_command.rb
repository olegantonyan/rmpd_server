class Deviceapi::Protocol::BaseCommand
  def self.available
    Dir["#{File.dirname(__FILE__)}/commands/*.rb"].map{|i| File.basename(i, '.rb') }
  end

  protected

  def clean_previous_commands(device_login, command_type)
    Deviceapi::MessageQueue.destroy_messages_with_type(device_login, command_type)
  end

  def type
    self.class.name.underscore.split('/').last
  end

end
