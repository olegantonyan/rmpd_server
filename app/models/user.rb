class User < ApplicationRecord
  include User::Auth
  include User::Gravatar

  has_paper_trail

  with_options inverse_of: :user do |a|
    a.has_many :user_company_memberships, dependent: :destroy
  end
  has_many :companies, -> { group('companies.id') }, through: :user_company_memberships
  has_many :devices, through: :companies

  validates :displayed_name, length: { maximum: 130 }

  before_save :set_defaults

  scope :available_for_notifications, -> {
    where.not(confirmed_at: nil, allow_notifications: false)
  }

  def to_s
    displayed_name || email
  end

  private

  def set_defaults
    return if companies.exists?
    companies << Company.demo
  end
end
