class DeviceGroupMembership < ActiveRecord::Base
  belongs_to :device
  belongs_to :device_group
end
