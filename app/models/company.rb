class Company < ApplicationRecord
  has_many :devices, inverse_of: :company, dependent: :restrict_with_error
  has_many :playlists, inverse_of: :company, dependent: :restrict_with_error
  has_many :media_items, inverse_of: :company, dependent: :restrict_with_error
  has_many :user_company_memberships, inverse_of: :company, dependent: :destroy
  has_many :invites, inverse_of: :company, dependent: :destroy
  has_many :users, through: :user_company_memberships

  validates :title, presence: true, length: { in: 4..100 }, uniqueness: true

  scope :search_query, ->(query) {
    q = "%#{query}%"
    where('LOWER(title) LIKE LOWER(?)', q)
  }

  def to_s
    title
  end

  def includes_user?(user)
    user_ids.include?(user&.id)
  end

  def serialize
    attributes.slice('id', 'title')
  end
end
