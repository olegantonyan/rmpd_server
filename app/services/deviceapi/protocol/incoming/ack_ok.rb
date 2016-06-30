class Deviceapi::Protocol::Incoming::AckOk < Deviceapi::Protocol::Incoming::BaseCommand
  # rubocop: disable Lint/UnusedMethodArgument
  def call(options = {})
    original_message = mq.remove(sequence_number)
    case original_message&.message_type
    when 'request_ssh_tunnel'
      Notifiers::SshTunnelNotifierJob.perform_later(device)
    end
  end
  # rubocop: enable Lint/UnusedMethodArgument
end
