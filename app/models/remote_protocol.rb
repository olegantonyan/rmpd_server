require 'json'

class RemoteProtocol
  
  def update_playlist(to_device)
    items = []
    to_device.playlist.media_items.each {|i| items << i.file_url }
    items << to_device.playlist.file.url
    RemoteInterface.new.send_message(to_device.login, json_for_update_playlist(items))
  end
  
  def delete_playlist(to_device)
    RemoteInterface.new.send_message(to_device.login, json_for_delete_playlist)
  end
  
  def process_incoming(from, msg, online=true)
    puts "#{from} is #{online ? 'online' : 'offline'} : '#{msg}'"
    
    d = Device.find_by(:login => from)
    unless d.nil?
      unless d.device_status.nil?
        d.device_status.update_attributes(:online => online, :now_playing => msg)
      else
        d.device_status = DeviceStatus.new
        d.device_status.online = online
        d.device_status.now_playing = msg
        d.device_status.save
      end
    else
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
  
  protected
  
  def serial_number_from_login(login)
    login.split("@")[0]
  end
  
  def json_for_update_playlist(items)
    {'type' => 'playlist', 'status' => 'update', 'items' => items}.to_json
  end
  
  def json_for_delete_playlist
    {'type' => 'playlist', 'status' => 'delete'}.to_json
  end
  
end