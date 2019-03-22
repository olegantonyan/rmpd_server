module Deviceapi
  class StatusController < Deviceapi::BaseController
    def create # rubocop: disable Metrics/AbcSize, Metrics/MethodLength
      outgoing_sequence_number = 0
      response_status = :ok
      receiver = Deviceapi::Receiver.new(device)
      receiver.receive(params, request.user_agent, request.headers['X-Sequence-Number'])
      queued_messsage_to_device, outgoing_sequence_number = receiver.dequeue
    rescue StandardError => err
      log_error(err)
      response_status = :unprocessable_entity
    ensure
      response.headers['X-Sequence-Number'] = outgoing_sequence_number.to_s
      render json: json(queued_messsage_to_device), status: response_status
    end

    private

    def json(msg)
      JSON.parse(msg || '')
    rescue JSON::ParserError
      {}
    end

    def log_error(err)
      Rails.logger.error("error processing message from device #{device.login}: #{err}\n#{err.backtrace}")
      Rollbar.error(err, "error processing message from device #{device.login}")
    end
  end
end
