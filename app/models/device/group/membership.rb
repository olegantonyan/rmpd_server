class Device::Group::Membership < ApplicationRecord
  has_paper_trail

  with_options inverse_of: :device_group_memberships do |a|
    a.belongs_to :device
    a.belongs_to :device_group, class_name: 'Device::Group'
  end

  def to_s
    "#{device} @ #{device_group}"
  end
end
