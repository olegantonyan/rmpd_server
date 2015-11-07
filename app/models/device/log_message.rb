require 'time'

class Device::LogMessage < ActiveRecord::Base
  self.inheritance_column = 'sti_type'

  belongs_to :device, inverse_of: :device_log_messages

  validates_presence_of :module, :level, :type, :localtime
  with_options maximum: 512 do
    validates_length_of :module, :level, :type
  end
  with_options maximum: 32768 do
    validates_length_of :user_agent, :details
  end

  def self.write(device, logdata, user_agent)
    begin
      log = new(:device => device, :localtime => Time.parse(logdata["localtime"]), :user_agent => user_agent)
      case logdata["type"]
      when "ack"
        log.module = "system"
        log.type = logdata["status"] == "ok" ? "ack_ok" : "ack_error"
        log.level = logdata["status"] == "ok" ? "info" : "error"
        log.details = logdata["message"]
      when "power"
        log.module = "system"
        log.level = "info"
        log.type = logdata["status"]
      when "playback"
        log.module = "player"
        log.level = "info"
        case logdata["status"]
        when "begin"
          log.type = "begin"
          log.details = logdata["track"].to_s
        when "end"
          log.type = "end"
          log.details = logdata["track"].to_s
        when "now_playing"
          return
        when "error"
          log.level = "warning"
          log.type = "error"
          log.details = logdata["track"].to_s
        when "update_playlist"
          log.type = "start update playlist"
          log.details = logdata["track"].join(", ")
        when "begin_playlist"
          log.type = "begin playlist"
          log.details = logdata["track"].join(", ")
        else
          log.type = "unknown"
        end
      else
        log.module = "unknown"
        log.level = "error"
        log.type = "unkwown"
      end
      log.save
    rescue => err
      logger.error("Error writing device log : " + err.to_s)
    end
  end

  rails_admin do
    visible false
  end

  def to_s
    "#{device.to_s} | #{self.module} | #{type} | #{localtime} | #{details}"
  end

end
