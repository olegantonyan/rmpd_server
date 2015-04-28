class DeviceStatus < ActiveRecord::Base
  has_paper_trail
  belongs_to :device
  
  validates_length_of :now_playing, :maximum => 1024
  
  scope :online, -> { where(:online => true) }
end
