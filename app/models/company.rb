class Company < ApplicationRecord
  has_paper_trail

  with_options inverse_of: :company do |a|
    a.has_many :devices
    a.has_many :playlists
    a.has_many :media_items
    a.has_many :user_company_memberships, dependent: :destroy
  end
  has_many :users, through: :user_company_memberships

  with_options presence: true do
    validates :title, length: { in: 4..100 }, uniqueness: true
  end

  filterrific(available_filters: %i(search_query))

  scope :search_query, -> (query) {
    q = "%#{query}%"
    where('LOWER(title) LIKE LOWER(?)', q)
  }

  def to_s
    title
  end
end
