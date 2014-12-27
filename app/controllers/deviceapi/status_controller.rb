class Deviceapi::StatusController < Deviceapi::DeviceapiController

  def index
    render json: { :ok => device.inspect}
  end
  
  def create
    queued_messsage_to_device = ""
    outgoing_sequence_number = 0
    response_status = :ok
    begin
      user_agent = request.headers["User-Agent"]
      incomming_sequence_number = response.headers["X-Sequence-Number"]
      data = request.body.read
      queued_messsage_to_device, outgoing_sequence_number = Deviceapi::Protocol.new.process(device, data, user_agent, incomming_sequence_number)
    rescue => err
      logger.error("Error processing message from device '#{device.login}' : " + err.to_s)
      response_status = :unprocessable_entity
    ensure
      response.headers["X-Sequence-Number"] = outgoing_sequence_number.to_s
      render :json => (JSON.parse(queued_messsage_to_device) rescue {}), :status => response_status
    end
  end
  
  private
  
end
