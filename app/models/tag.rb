class Tag < ApplicationRecord
  has_many :taggings, inverse_of: :tag, dependent: :destroy

  validates :name, presence: true, uniqueness: true

  scope :ordered, -> { order(:name) }
  scope :all_with_taggings_count, -> { left_outer_joins(:taggings).select('tags.*, COUNT(taggings.id) AS taggings_count').group('tags.id') }

  def to_s
    name
  end

  def serialize
    attributes.slice('id', 'name').freeze
  end
end
