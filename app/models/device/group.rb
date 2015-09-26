class Device::Group < ActiveRecord::Base
  has_paper_trail
  has_many :device_group_memberships, dependent: :destroy, inverse_of: :device_group, class_name: Device::Group::Membership, foreign_key: :device_group_id
  has_many :devices, through: :device_group_memberships

  validates :title, presence: true, length: {in: 4..100}, uniqueness: true

  rails_admin do
    list do
      exclude_fields :versions
    end
    show do
      exclude_fields :device_group_memberships
    end
    edit do
      exclude_fields :versions, :device_group_memberships
    end
  end

  def to_s
    "#{title}"
  end

end
