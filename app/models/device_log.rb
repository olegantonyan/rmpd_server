require 'time'

class DeviceLog < ActiveRecord::Base
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
      logger.error("Error writing device log : " + err.to_s)
    end
  end
    
end