class Tagging < ApplicationRecord
  belongs_to :tag, inverse_of: :taggings
  belongs_to :taggable
end
