class Device < ActiveRecord::Base
  belongs_to :playlist
  has_one :device_status
  
end
