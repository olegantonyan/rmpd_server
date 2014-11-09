class RemoteInterface
  
  def send_message(to, msg)
    Xmpp.message(to, msg)
  end
  
  def received_message(from, msg)
    RemoteProtocol.new.process_incoming(from, msg, true)
  end
  
  def received_presence(from, online, status_text)
    RemoteProtocol.new.process_incoming(from, status_text, online)    
  end
  
  def server_online?
    Xmpp.online?
  end
  
end