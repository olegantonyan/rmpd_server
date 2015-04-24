class DeviceGroup < ActiveRecord::Base
  has_many :device_group_memberships
  has_many :devices, through: :device_group_memberships
end
