class UserCompanyMembership < ApplicationRecord
  belongs_to :user, inverse_of: :user_company_memberships
  belongs_to :company, inverse_of: :user_company_memberships

  validates :title, length: { maximum: 130 }
  validates :user, presence: true
  validates :company, presence: true

  def to_s
    "#{user} in #{company}"
  end
end
