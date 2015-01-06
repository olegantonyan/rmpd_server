require 'json'

class Deviceapi::Protocol
  
  def update_playlist(to_device)
    unless to_device.playlist.nil?
      items = []
      to_device.playlist.media_items.each {|i| items << i.file_url }
      p = Playlist.find(to_device.playlist.id) #note: http://stackoverflow.com/questions/26923249/rails-carrierwave-manual-file-upload-wrong-url
      items << p.file_url
        
      clean_previous_commands(to_device.login, type_for_update_playlist)
      Deviceapi::MessageQueue.enqueue(to_device.login, json_for_update_playlist(items), type_for_update_playlist)
    end
  end
  
  def delete_playlist(to_device)
    clean_previous_commands(to_device.login, type_for_delete_playlist)
    Deviceapi::MessageQueue.enqueue(to_device.login, json_for_delete_playlist, type_for_delete_playlist)
  end
  
  def request_ssh_tunnel(tunnel)
    clean_previous_commands(tunnel.device.login, type_for_request_ssh_tunnel)
    Deviceapi::MessageQueue.enqueue(tunnel.device.login, json_for_request_ssh_tunnel(tunnel), type_for_request_ssh_tunnel)
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
    when "ack"
      if data["status"] == "ok"
        Deviceapi::MessageQueue.remove(incomming_sequence_number)
      else
        if Deviceapi::MessageQueue.retries(incomming_sequence_number) < 15
          Deviceapi::MessageQueue.reenqueue(incomming_sequence_number)
        else
          Rails.logger.warn("Maximum retries reached for device '#{from_device.login}'")
          Deviceapi::MessageQueue.remove(incomming_sequence_number)
        end
      end
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
    end
    
    from_device.device_status.save if from_device.device_status.new_record? or from_device.device_status.changed?   
    
    Deviceapi::MessageQueue.dequeue(from_device.login)
  end
  
  private
    
    def json_for_update_playlist(items)
      {'type' => 'playlist', 'status' => 'update', 'items' => items}.to_json
    end
    
    def type_for_update_playlist
      "update_playlist"
    end
    
    def json_for_abort(sequence_number)
      {'type' => 'abort_command', 'sequence_number' => sequence_number}
    end
    
    def type_for_abort
      "abort_command"
    end
    
    def json_for_delete_playlist
      {'type' => 'playlist', 'status' => 'delete'}.to_json
    end
    
    def type_for_delete_playlist
      "delete_playlist"
    end
    
    def json_for_request_ssh_tunnel(tunnel)
      {'type' => 'ssh_tunnel', 'status' => 'open', 'server' => tunnel.server, 'server_port' => tunnel.server_port, \
        'external_port' => tunnel.external_port, 'internal_port' => tunnel.internal_port, 'duration' => tunnel.open_duration, \
        'username' => tunnel.username}.to_json
    end
    
    def type_for_request_ssh_tunnel
      "request_ssh_tunnel"
    end
    
    def write_device_log(device, logdata, user_agent)
      DeviceLog.write(device, logdata, user_agent)
    end
    
    def clean_previous_commands(device_login, command_type)
      Deviceapi::MessageQueue.destroy_messages_with_type(device_login, command_type)
    end
  
end