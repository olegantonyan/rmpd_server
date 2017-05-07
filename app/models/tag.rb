class Tag < ApplicationRecord
  has_paper_trail

  has_many :taggings, inverse_of: :tag

  validates :name, presence: true, uniqueness: true
end
