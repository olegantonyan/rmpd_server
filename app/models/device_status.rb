class DeviceStatus < ActiveRecord::Base
  belongs_to :device
  
  scope :online, -> { where(:online => true) }
end
