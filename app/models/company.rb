class Company < ActiveRecord::Base
  has_paper_trail
  has_many :devices
  has_many :user_company_memberships, dependent: :destroy
  has_many :users, through: :user_company_memberships
  
  validates :title, presence: true, length: {in: 4..100}, uniqueness: true
  
  
      
  rails_admin do 
    list do
      field :title
      field :created_at
      field :users
    end
    #object_label_method do
    #  :custom_label_method
    #end
    edit do
      configure :versions do 
        hide
      end
      configure :user_company_memberships do 
        hide
      end
    end
  end
  
end
