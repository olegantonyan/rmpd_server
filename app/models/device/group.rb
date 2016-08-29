class Device::Group < ApplicationRecord
  has_paper_trail

  has_many :device_group_memberships, dependent: :destroy, inverse_of: :device_group, class_name: 'Device::Group::Membership', foreign_key: :device_group_id
  has_many :devices, through: :device_group_memberships

  validates :title, presence: true, length: { in: 4..100 }, uniqueness: true
  validates :devices, presence: true

  filterrific(available_filters: %i(search_query with_device_id))

  scope :search_query, -> (query) {
    q = "%#{query}%"
    where('LOWER(title) LIKE LOWER(?)', q)
  }
  scope :with_device_id, -> (ids) { joins(:devices).where(devices: { id: [*ids] }) }

  def to_s
    title
  end
end
