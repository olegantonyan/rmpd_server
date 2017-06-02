class Company < ApplicationRecord
  has_paper_trail

  with_options inverse_of: :company do |a|
    a.has_many :devices
    a.has_many :playlists
    a.has_many :media_items
    a.with_options dependent: :destroy do |aa|
      aa.has_many :user_company_memberships
      aa.has_many :invites
    end
  end
  has_many :users, through: :user_company_memberships

  with_options presence: true do
    validates :title, length: { in: 4..100 }, uniqueness: true
  end

  filterrific(available_filters: %i[search_query])

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
end
