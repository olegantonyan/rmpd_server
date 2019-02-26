class UserCompanyMembership < ApplicationRecord
  with_options inverse_of: :user_company_memberships do |a|
    a.belongs_to :user
    a.belongs_to :company
  end

  validates :title, length: { maximum: 130 }
  with_options presence: true do
    validates :user
    validates :company
  end

  def to_s
    "#{user} in #{company}"
  end
end
