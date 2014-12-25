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
    
end