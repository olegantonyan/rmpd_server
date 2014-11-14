require 'json'

class RemoteProtocol
  
  def update_playlist(to_device)
    items = []
    to_device.playlist.media_items.each {|i| items << i.file_url }
    p = Playlist.find(to_device.playlist.id) #note: http://stackoverflow.com/questions/26923249/rails-carrierwave-manual-file-upload-wrong-url
    items << p.file_url
    RemoteInterface.new.send_message(to_device.login, json_for_update_playlist(items))
  end
  
  def delete_playlist(to_device)
    RemoteInterface.new.send_message(to_device.login, json_for_delete_playlist)
  end
  
  def process_incoming(from, msg, online)
    puts "#{from} is #{online ? 'online' : 'offline'} : '#{msg}'"
    
    now_playing = if msg.start_with?("{")
      data = JSON.parse(msg)
      case data["type"]
        when "power" 
          "power_on"
        when "playback"
          data["status"] == "play" ? data["now_playing"] : "stopped"
        else 
          "unknown"
      end
    else
      msg
    end
    
    update_device(from, online, now_playing)      
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
  
  private
  
  def update_device(login, online, now_playing)
    
    d = Device.find_by(:login => login)
    unless d.nil?
      unless d.device_status.nil?
        d.device_status.update_attributes(:online => online, :now_playing => now_playing)
      else
        d.device_status = DeviceStatus.new(:online => online, :now_playing => now_playing)
        d.device_status.save
      end
    else
      d = Device.new(:login => login, :serial_number => serial_number_from_login(login), :name => "auto added device #{login}")
      d.device_status = DeviceStatus.new(:online => online, :now_playing => now_playing)
      d.save
    end
  end
  
end