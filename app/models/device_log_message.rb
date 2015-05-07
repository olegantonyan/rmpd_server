require 'time'

class DeviceLogMessage < ActiveRecord::Base
  belongs_to :device 
    
  validates_presence_of :module
  validates_presence_of :level
  validates_presence_of :etype
  validates_presence_of :localtime
  validates_length_of :module, :maximum => 250
  validates_length_of :level, :maximum => 250
  validates_length_of :etype, :maximum => 250
  validates_length_of :user_agent, :maximum => 1024
  validates_length_of :details, :maximum => 1024
  
  def self.write(device, logdata, user_agent)
    begin
      log = new(:device => device, :localtime => Time.parse(logdata["localtime"]), :user_agent => user_agent)
      case logdata["type"]
      when "ack"
        log.module = "system"
        log.etype = logdata["status"] == "ok" ? "ack_ok" : "ack_error"
        log.level = logdata["status"] == "ok" ? "info" : "error"
        log.details = logdata["message"]
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
          log.details = logdata["track"].to_s
        when "end"
          log.etype = "end"
          log.details = logdata["track"].to_s
        when "now_playing"
          return
        when "error"
          log.level = "warning"
          log.etype = "error"
          log.details = logdata["track"].to_s
        when "update_playlist"
          log.etype = "start update playlist"
          log.details = logdata["track"].join(", ")
        when "begin_playlist"
          log.etype = "begin playlist"
          log.details = logdata["track"].join(", ")
        else
          log.etype = "unknown"
        end
      else
        log.module = "unknown"
        log.level = "error"
        log.etype = "unkwown"
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
    "#{device.to_s} | #{self.module} | #{etype} | #{localtime} | #{details}"
  end
    
end