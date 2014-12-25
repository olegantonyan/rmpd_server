require 'json'
require 'time'

class Deviceapi::Protocol
  
  def update_playlist(to_device)
    items = []
    to_device.playlist.media_items.each {|i| items << i.file_url }
    p = Playlist.find(to_device.playlist.id) #note: http://stackoverflow.com/questions/26923249/rails-carrierwave-manual-file-upload-wrong-url
    items << p.file_url
    Deviceapi::MessageQueue.enqueue(to_device.login, json_for_update_playlist(items))
  end
  
  def delete_playlist(to_device)
    Deviceapi::MessageQueue.enqueue(to_device.login, json_for_delete_playlist)
  end
  
  def clear_queue(for_device)
    Deviceapi::MessageQueue.destroy_all_messages for_device.login
  end
  
  def process_incoming(from, data, user_agent)
    device = obtain_device(from)
    return if device.nil?
    device.device_status.online = true
    device.device_status.touch
    
    write_device_log(device, data, user_agent)
    case data["type"]
      when "power"
        if data["status"] == "on"
          device.device_status.poweredon_at = Time.now
        end
      when "playback"
        if data["status"] == "now_playing"
          device.device_status.now_playing = data["track"]
          if data["track"] == "none"
            update_playlist(device)
          elsif data["track"] == "updating_now"
            #nothing to do
          end
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
    
    def write_device_log(device, logdata, user_agent)
      begin
        log = DeviceLog.new
        log.device = device
        log.localtime = Time.parse logdata["localtime"]
        log.user_agent = user_agent
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
          when "now_playing"
            return
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
        Rails.logger.error("Error writing device log : " + err.to_s)
      end
    end
  
  
end