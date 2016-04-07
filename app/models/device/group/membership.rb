class Device::Group::Membership < ApplicationRecord
  has_paper_trail

  belongs_to :device, inverse_of: :device_group_memberships
  belongs_to :device_group, inverse_of: :device_group_memberships, class_name: 'Device::Group'

  def to_s
    "#{device} @ #{device_group}"
  end
end
