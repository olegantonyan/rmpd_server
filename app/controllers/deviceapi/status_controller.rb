class Deviceapi::StatusController < Deviceapi::BaseController
  def create
    outgoing_sequence_number = 0
    response_status = :ok

    device.receive_from(params, request.user_agent, request.headers['X-Sequence-Number'])
    queued_messsage_to_device, outgoing_sequence_number = device.dequeue
  rescue => err
    notify_exception(err)
    logger.error("error processing message from device #{device.login}: #{err.to_s}\n#{err.backtrace}")
    response_status = :unprocessable_entity
  ensure
    response.headers['X-Sequence-Number'] = outgoing_sequence_number.to_s
    render json: (JSON.parse(queued_messsage_to_device) rescue {}), status: response_status
  end
end
