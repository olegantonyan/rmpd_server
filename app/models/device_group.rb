class DeviceGroup < ActiveRecord::Base
  has_paper_trail
  has_many :device_group_memberships, dependent: :destroy
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
  
end
