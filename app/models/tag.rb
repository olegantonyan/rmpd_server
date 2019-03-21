class Tag < ApplicationRecord
  has_many :taggings, inverse_of: :tag, dependent: :destroy

  validates :name, presence: true, uniqueness: true

  scope :ordered, -> { order(:name) }

  def to_hash
    attributes.slice('id', 'name').freeze
  end
end
