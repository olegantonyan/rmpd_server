class Deviceapi::Protocol::Incoming::AckOk < Deviceapi::Protocol::Incoming::BaseCommand
  # rubocop: disable Lint/UnusedMethodArgument
  def call(options = {})
    mq.remove(sequence_number)
  end
  # rubocop: enable Lint/UnusedMethodArgument
end
