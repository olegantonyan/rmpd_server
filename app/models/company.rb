class Company < ActiveRecord::Base
  has_paper_trail
  has_many :devices
  has_many :media_items
  has_many :playlists
  has_many :user_company_memberships, dependent: :destroy
  has_many :users, through: :user_company_memberships
  
  validates :title, presence: true, length: {in: 4..100}, uniqueness: true
  
  DEMO_TITLE = 'Demo'
   
  rails_admin do 
    list do
      field :title
      field :created_at
      field :users
    end
    edit do
      exclude_fields :versions, :user_company_memberships
    end
  end
  
end
