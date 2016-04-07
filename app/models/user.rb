class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :validatable, :confirmable

  has_paper_trail

  with_options inverse_of: :user do |a|
    a.has_many :user_company_memberships, dependent: :destroy
  end
  has_many :companies, -> { group('companies.id') }, through: :user_company_memberships

  validates :displayed_name, length: { maximum: 130 }

  before_save :set_defaults

  scope :available_for_notifications, -> {
    where.not(confirmed_at: nil, allow_notifications: false)
  }

  def devices
    Device.where(company: companies)
  end

  def gravatar_url
    @_gravatar_url ||= "https://gravatar.com/avatar/#{Digest::MD5.hexdigest(email).downcase}.png"
  end

  def to_s
    displayed_name || email
  end

  private

  def set_defaults
    return if companies.any?
    companies << Company.demo
  end
end
