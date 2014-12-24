class Deviceapi::StatusController < Deviceapi::DeviceapiController

  def index
    render json: { :ok => device.inspect}
  end
  
  def create
    queued_messsage = ""
    sequence_number = 0
    response_status = :ok
    begin
      data = JSON.parse(request.body.read)
      puts data.inspect
      if data["type"] == "ack"
        if data["status"] == "ok"
          Deviceapi::MessageQueue.remove(request.headers["X-Sequence-Number"])
        else
          Deviceapi::MessageQueue.reenqueue(request.headers["X-Sequence-Number"])
        end
      end
      user_agent = request.headers["User-Agent"]
      Deviceapi::Protocol.new.process_incoming(device.login, data, user_agent)
      queued_messsage, sequence_number = Deviceapi::MessageQueue.dequeue(device.login)
    rescue => err
      logger.error("Error processing message from device '#{device.login}' : " + err.to_s)
      response_status = :unprocessable_entity
    ensure
      response.headers["X-Sequence-Number"] = sequence_number.to_s
      render :json => (JSON.parse(queued_messsage) rescue {}), :status => response_status
    end
  end
  
  private
  
end
