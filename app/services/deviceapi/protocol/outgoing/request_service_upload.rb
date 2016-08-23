class Deviceapi::Protocol::Outgoing::RequestServiceUpload < Deviceapi::Protocol::Outgoing::BaseCommand
  def call(_options = {})
    clean_previous_commands
    enqueue(json)
  end

  private

  def json
    {}
  end
end
