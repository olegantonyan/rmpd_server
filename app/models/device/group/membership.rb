class Device::Group::Membership < ActiveRecord::Base
  has_paper_trail
  belongs_to :device, inverse_of: :device_group_memberships
  belongs_to :device_group, inverse_of: :device_group_memberships, class_name: 'Device::Group'

  def to_s
    "#{device.to_s} @ #{device_group.to_s}"
  end
end
