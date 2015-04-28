class DeviceGroupMembership < ActiveRecord::Base
  has_paper_trail
  belongs_to :device
  belongs_to :device_group
end
