class Device::Group < ApplicationRecord
  has_many :device_group_memberships, dependent: :destroy, inverse_of: :device_group, class_name: 'Device::Group::Membership', foreign_key: :device_group_id
  has_many :devices, through: :device_group_memberships

  validates :title, presence: true, length: { in: 4..100 }, uniqueness: true

  def to_s
    title
  end
end
