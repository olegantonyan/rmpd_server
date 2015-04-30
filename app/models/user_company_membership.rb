class UserCompanyMembership < ActiveRecord::Base
  has_paper_trail
  belongs_to :user
  belongs_to :company
  
  validates :title, length: {maximum: 130}
  
  rails_admin do 
    list do
      field :title
      field :user
      field :company
    end
    show do
      exclude_fields :versions
    end
    edit do
      exclude_fields :versions
    end
  end
  
end
