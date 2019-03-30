class Tag < ApplicationRecord
  has_many :taggings, inverse_of: :tag, dependent: :destroy

  validates :name, presence: true, uniqueness: true

  scope :ordered, -> { order(:name) }

  def to_s
    name
  end

  def serialize
    attributes.slice('id', 'name').freeze
  end
end
