class Deviceapi::StatusController < Deviceapi::BaseController
  # rubocop: disable Metrics/AbcSize
  def create
    outgoing_sequence_number = 0
    response_status = :ok
    device.receive_from(params, request.user_agent, request.headers['X-Sequence-Number'])
    queued_messsage_to_device, outgoing_sequence_number = device.dequeue
  rescue => err
    log_error(err)
    response_status = :unprocessable_entity
  ensure
    response.headers['X-Sequence-Number'] = outgoing_sequence_number.to_s
    render json: json(queued_messsage_to_device), status: response_status
  end
  # rubocop: enable Metrics/AbcSize

  private

  def json(msg)
    JSON.parse(msg)
  rescue JSON::ParserError
    {}
  end

  def log_error(err)
    Notifiers::ExceptionNotifierJob.call(err)
    logger.error("error processing message from device #{device.login}: #{err}\n#{err.backtrace}")
  end
end
