class Deviceapi::Protocol::Incoming::AckFail < Deviceapi::Protocol::Incoming::BaseCommand
  MAX_RETRIES = 15

  # rubocop: disable Lint/UnusedMethodArgument
  def call(options = {})
    if mq.retries(sequence_number) < MAX_RETRIES
      notify_error 'retry command'
      mq.reenqueue(sequence_number)
    else
      notify_error "maximum retries of #{MAX_RETRIES} reached"
      mq.remove(sequence_number)
    end
  end
  # rubocop: enable Lint/UnusedMethodArgument

  private

  def notify_error(msg)
    full_message = "#{msg} (device #{device.login}, sequence_number #{sequence_number}, command_type #{mq.message_type_for_sequence_number(sequence_number)}))"
    Rails.logger.error full_message
    Notifiers::ErrorNotifierJob.perform_later(device, full_message)
  end
end
