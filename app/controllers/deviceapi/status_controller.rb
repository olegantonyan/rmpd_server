class Deviceapi::StatusController < Deviceapi::BaseController
  include Deviceapi::Receiver

  def create
    outgoing_sequence_number = 0
    response_status = :ok

    queued_messsage_to_device, outgoing_sequence_number = received_from_device(device, params, request.user_agent, request.headers['X-Sequence-Number'])
  rescue => err
    logger.error("Error processing message from device #{device.login}: #{err.to_s}\n#{err.backtrace}")
    response_status = :unprocessable_entity
  ensure
    response.headers['X-Sequence-Number'] = outgoing_sequence_number.to_s
    render json: (JSON.parse(queued_messsage_to_device) rescue {}), status: response_status
  end

end
