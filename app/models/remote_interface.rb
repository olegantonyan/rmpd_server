class RemoteInterface
  
  def send_message(to, msg)
    Xmpp.message(to, msg)
  end
  
  def received_message(from, msg)
    begin
      RemoteProtocol.new.process_incoming(from, msg, true)
    rescue => err
      logger.error("Error processing message '#{msg}' from '#{from}' " + err.to_s)
    end 
  end
  
  def received_presence(from, online, status_text)
    begin
      RemoteProtocol.new.process_incoming(from, status_text, online)
    rescue => err
      logger.error("Error processing presense '#{online.to_s}'|'#{status_text}' from '#{from}' " + err.to_s)
    end   
  end
  
  def server_online?
    Xmpp.online?
  end
  
end