module Taggable
  extend ActiveSupport::Concern

  included do
    has_many :taggings, as: :taggable
    has_many :tags, through: :taggings

    scope :with_tag_id, ->(id) { joins(:tags).where(tags: { id: id }) }
    scope :with_tag_name, ->(name) { joins(:tags).where(tags: { name: name }) }
  end
end
