class DeviceStatus < ActiveRecord::Base
  belongs_to :device
  
  validates_length_of :now_playing, :maximum => 1024
  
  scope :online, -> { where(:online => true) }
  
  rails_admin do
    visible false
  end
  
end
