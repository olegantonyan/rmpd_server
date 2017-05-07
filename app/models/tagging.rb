class Tagging < ApplicationRecord
  has_paper_trail

  belongs_to :tag, inverse_of: :taggings
  belongs_to :taggable
end
