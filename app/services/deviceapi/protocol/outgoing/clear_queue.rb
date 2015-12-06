class Deviceapi::Protocol::Outgoing::ClearQueue < Deviceapi::Protocol::Outgoing::BaseCommand
  # rubocop: disable Lint/UnusedMethodArgument
  def call(options = {})
    mq.destroy_all_messages device.login
  end
  # rubocop: enable Lint/UnusedMethodArgument
end
