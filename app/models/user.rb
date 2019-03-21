class User < ApplicationRecord
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :validatable, :confirmable

  has_many :user_company_memberships, inverse_of: :user, dependent: :destroy
  has_many :invites, inverse_of: :user, dependent: :destroy
  has_many :companies, -> { group('companies.id') }, through: :user_company_memberships
  has_many :devices, through: :companies

  validates :displayed_name, length: { maximum: 130 }

  scope :search_query, ->(query) {
    q = "%#{query}%"
    where('LOWER(email) LIKE LOWER(?) OR LOWER(displayed_name) LIKE LOWER(?)', q, q)
  }
  scope :with_company_id, ->(*ids) { joins(:companies).where(companies: { id: [*ids] }) }

  def gravatar_url
    @gravatar_url ||= "https://gravatar.com/avatar/#{Digest::MD5.hexdigest(email).downcase}.png"
  end

  def to_s
    displayed_name.presence || email
  end
end
