class User < ApplicationRecord
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :validatable, :confirmable

  with_options inverse_of: :user, dependent: :destroy do |a|
    a.has_many :user_company_memberships
    a.has_many :invites
  end
  has_many :companies, -> { group('companies.id') }, through: :user_company_memberships
  has_many :devices, through: :companies

  validates :displayed_name, length: { maximum: 130 }

  scope :available_for_notifications, -> {
    where.not(confirmed_at: nil, allow_notifications: false)
  }
  scope :search_query, ->(query) {
    q = "%#{query}%"
    where('LOWER(email) LIKE LOWER(?) OR LOWER(displayed_name) LIKE LOWER(?)', q, q)
  }
  scope :with_company_id, ->(*ids) { joins(:companies).where(companies: { id: [*ids] }) }
  filterrific(available_filters: %i[search_query with_company_id])

  def gravatar_url
    @gravatar_url ||= "https://gravatar.com/avatar/#{Digest::MD5.hexdigest(email).downcase}.png"
  end

  def to_s
    displayed_name.presence || email
  end

  def many_companies?
    companies.size.to_i > 1
  end
end
