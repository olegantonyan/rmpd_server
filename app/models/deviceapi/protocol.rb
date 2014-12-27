require 'json'
require 'time'

class Deviceapi::Protocol
  
  def update_playlist(to_device)
    items = []
    unless to_device.playlist.nil?
      to_device.playlist.media_items.each {|i| items << i.file_url }
      p = Playlist.find(to_device.playlist.id) #note: http://stackoverflow.com/questions/26923249/rails-carrierwave-manual-file-upload-wrong-url
      items << p.file_url
      Deviceapi::MessageQueue.enqueue(to_device.login, json_for_update_playlist(items))
    end
  end
  
  def delete_playlist(to_device)
    Deviceapi::MessageQueue.enqueue(to_device.login, json_for_delete_playlist)
  end
  
  def clear_queue(for_device)
    Deviceapi::MessageQueue.destroy_all_messages for_device.login
  end
  
  def process(from_device, raw_data, user_agent, incomming_sequence_number)
    return if from_device.nil?
    
    if from_device.device_status.nil?
      from_device.device_status = DeviceStatus.new
    end
    
    from_device.device_status.online = true
    from_device.device_status.touch
    
    data = JSON.parse(raw_data)
    
    write_device_log(from_device, data, user_agent)
    case data["type"]
      when "power"
        if data["status"] == "on" 
          from_device.device_status.poweredon_at = Time.now
          Deviceapi::MessageQueue.reenqueue_all(from_device.login)
        end
      when "playback"
        if data["status"] == "now_playing"
          from_device.device_status.now_playing = data["track"]
          if data["track"] == "none"
            update_playlist(from_device)
          elsif data["track"] == "updating_now"
            #nothing to do
          end
        end
       when "ack"
        if data["status"] == "ok"
          Deviceapi::MessageQueue.remove(incomming_sequence_number)
        else
          Deviceapi::MessageQueue.reenqueue(incomming_sequence_number)
        end

    end
    
    save_device(from_device)
    
    Deviceapi::MessageQueue.dequeue(from_device.login)
  end
  
  private
    
    def json_for_update_playlist(items)
      {'type' => 'playlist', 'status' => 'update', 'items' => items}.to_json
    end
    
    def json_for_delete_playlist
      {'type' => 'playlist', 'status' => 'delete'}.to_json
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
          when "error"
            log.level = "warning"
            log.etype = "error"
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