class Deviceapi::Protocol::Outgoing::RequestServiceUpload < Deviceapi::Protocol::Outgoing::BaseCommand
  def call(_options = {})
    clean_previous_commands
    enqueue(json)
  end

  def ack(ok, sequence_number, _data = {})
    super
    Notifiers::ServiceUploadNotifierJob.perform_later(device) if ok
  end

  private

  def json
    {}
  end
end
