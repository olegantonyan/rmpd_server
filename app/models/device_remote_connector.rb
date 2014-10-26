class DeviceRemoteConnector
  
  def send_message(to, msg)
    Xmpp.message(to, msg)
  end
  
  def received_message(from, msg)
    send_message(from, "I've got you: #{msg}")
  end
  
  def received_presence(from, online, status_text)
    puts "#{from} is #{online ? 'online' : 'offline'} : '#{status_text}'"
    d = Device.find_by(:login => from)
    if d != nil
      if d.device_status != nil
        d.device_status.update_attributes(:online => online, :last_seen => Time.now, :now_playing => status_text)
      else
        d.device_status = DeviceStatus.new
        d.device_status.online = online
        d.device_status.last_seen = Time.now
        d.device_status.now_playing = status_text
        d.device_status.save
      end
      
    end
    
  end
  
  def server_online?
    return Xmpp.online?
  end
  
end