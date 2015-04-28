class Company < ActiveRecord::Base
  has_paper_trail
  has_many :devices
  has_many :user_company_memberships
  has_many :users, through: :user_company_memberships
end
