class DeviceGroup < ActiveRecord::Base
  has_many :devices, through: :device_group_membership
end
