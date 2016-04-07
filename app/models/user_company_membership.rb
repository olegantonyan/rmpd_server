class UserCompanyMembership < ApplicationRecord
  with_options inverse_of: :user_company_memberships do |a|
    a.belongs_to :user
    a.belongs_to :company
  end

  validates :title, length: { maximum: 130 }

  before_save :set_defaults

  def to_s
    "#{user} in #{company}"
  end
end
