class RemoteProtocol
  
  def serial_number_from_login(login)
    login.split("@")[0]
  end
  
  def process_incoming(from, msg, online=true)
    puts "#{from} is #{online ? 'online' : 'offline'} : '#{msg}'"
    
    d = Device.find_by(:login => from)
    if d != nil
      if d.device_status != nil
        d.device_status.update_attributes(:online => online, :now_playing => msg)
      else
        d.device_status = DeviceStatus.new
        d.device_status.online = online
        d.device_status.now_playing = msg
        d.device_status.save
      end
    else
      puts "creating new device"
      d = Device.new
      d.login = from
      d.serial_number = serial_number_from_login d.login
      d.name = "auto added device #{d.serial_number}"
      d.device_status = DeviceStatus.new
      d.device_status.online = online
      d.device_status.now_playing = msg
      d.save
    end
    
  end
  
  def server_online?
    RemoteInterface.new.server_online?
  end
  
end