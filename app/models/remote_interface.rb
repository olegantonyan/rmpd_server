class RemoteInterface
  
  def send_message(to, msg)
    Xmpp.message(to, msg)
  end
  
  def received_message(from, msg)
    begin
      RemoteProtocol.new.process_incoming(from, msg, true)
    rescue => err
      logger.error("RemoteInterface.received_message #####\n" + err.to_s)
    end 
  end
  
  def received_presence(from, online, status_text)
    begin
      RemoteProtocol.new.process_incoming(from, status_text, online)
    rescue => err
      logger.error("RemoteInterface.received_presence #####\n" + err.to_s)
    end   
  end
  
  def server_online?
    Xmpp.online?
  end
  
end