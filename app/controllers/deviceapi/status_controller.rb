class Deviceapi::StatusController < Deviceapi::DeviceapiController

  def index
    render json: { :ok => device.inspect}
  end
  
  def create
    queued_messsage_to_client = {}
    begin
      Deviceapi::Protocol.new.process_incoming(device.login, request.body)
      queued_messsage_to_client = DeviceApi::MessageQueue.new.deque(device.login)
    rescue => err
      logger.error("Error processing message from device #{device.login} " + err.to_s)
    ensure
      render json: queued_messsage_to_client
    end
  end
  
  private
  
end
