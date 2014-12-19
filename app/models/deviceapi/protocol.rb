require 'json'
require 'time'

class Deviceapi::Protocol
  
  def update_playlist(to_device)
    items = []
    to_device.playlist.media_items.each {|i| items << i.file_url }
    p = Playlist.find(to_device.playlist.id) #note: http://stackoverflow.com/questions/26923249/rails-carrierwave-manual-file-upload-wrong-url
    items << p.file_url
    #RemoteInterface.new.send_message(to_device.login, json_for_update_playlist(items))
    #TODO
  end
  
  def delete_playlist(to_device)
    #RemoteInterface.new.send_message(to_device.login, json_for_delete_playlist)
    #TODO
  end
  
  def process_incoming(from, msg, online)
    return if from.nil? or msg.nil? or online.nil?
    puts "#{from} is #{online ? 'online' : 'offline'} : '#{msg}'"
    
    device = obtain_device(from)
    return if device.nil?
    device.device_status.online = online
    
    data = JSON.parse(msg)
    write_device_log(device, data)
    case data["type"]
      when "power"
        if data["status"] == "on"
          device.device_status.poweredon_at = Time.now
        end
      when "playback"
        if data["status"] == "now_playing"
          device.device_status.now_playing = data["track"]
        end
    end
    
    save_device(device)
  end
  
  private
    
    def json_for_update_playlist(items)
      {'type' => 'playlist', 'status' => 'update', 'items' => items}.to_json
    end
    
    def json_for_delete_playlist
      {'type' => 'playlist', 'status' => 'delete'}.to_json
    end
    
    def obtain_device(login)
      d = Device.find_by(:login => login)
      if d.nil?
        nil
      else
        if d.device_status.nil?
          d.device_status = DeviceStatus.new
        end
      end
      d
    end
    
    def save_device(device)
      device.save if device.new_record? or device.changed?
      device.device_status.save if device.device_status.new_record? or device.device_status.changed?   
    end
    
    def write_device_log(device, logdata)
      begin
        log = DeviceLog.new
        log.device = device
        log.localtime = Time.parse logdata["localtime"]
        case logdata["type"]
        when "power"
          log.module = "system"
          log.level = "info"
          log.etype = logdata["status"]
        when "playback"
          log.module = "player"
          log.level = "info"
          case logdata["status"]
          when "begin"
            log.etype = "begin"
          when "end"
            log.etype = "end"
          else
            log.etype = "unkwown"
          end
          log.details = logdata["track"]
        else
          log.module = "unknown"
          log.level = "error"
          log.etype = "unkwown"
        end
        log.save
      rescue => err
        logger.error("Error writing device log " + err.to_s)
      end
    end
  
end