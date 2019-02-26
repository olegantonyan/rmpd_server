class Tag < ApplicationRecord
  has_many :taggings, inverse_of: :tag

  validates :name, presence: true, uniqueness: true
end
