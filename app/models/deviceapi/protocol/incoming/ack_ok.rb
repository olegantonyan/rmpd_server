class Deviceapi::Protocol::Incoming::AckOk < Deviceapi::Protocol::Incoming::BaseCommand
  def call(options = {})
    mq.remove(sequence_number)
  end
end
