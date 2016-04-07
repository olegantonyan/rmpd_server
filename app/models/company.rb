class Company < ApplicationRecord
  has_paper_trail

  find_or_create_by!(title: 'Demo')

  with_options inverse_of: :company do |a|
    a.has_many :devices
    a.has_many :playlists
    a.has_many :media_items
    a.has_many :user_company_memberships, dependent: :destroy
  end
  has_many :users, through: :user_company_memberships

  validates :title, presence: true, length: { in: 4..100 }, uniqueness: true

  def self.demo
    find_by!(title: 'Demo')
  end

  def to_s
    title
  end
end
