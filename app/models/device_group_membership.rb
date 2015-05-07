class DeviceGroupMembership < ActiveRecord::Base
  has_paper_trail
  belongs_to :device
  belongs_to :device_group
  
  def to_s
    "#{device.to_s} @ #{device_group.to_s}"
  end
end
