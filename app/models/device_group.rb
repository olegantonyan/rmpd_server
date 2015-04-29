class DeviceGroup < ActiveRecord::Base
  has_paper_trail
  has_many :device_group_memberships, dependent: :destroy
  has_many :devices, through: :device_group_memberships
  
  validates :title, presence: true, length: {in: 4..100}, uniqueness: true
end
