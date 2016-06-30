class Deviceapi::Protocol::Incoming::AckOk < Deviceapi::Protocol::Incoming::BaseCommand
  # rubocop: disable Lint/UnusedMethodArgument
  def call(options = {})
    original_message = mq.remove(sequence_number)
    case original_message&.message_type
    when 'request_ssh_tunnel'
      SshTunnelNotifierJob.perform_later
    end
    original_message
  end
  # rubocop: enable Lint/UnusedMethodArgument
end
