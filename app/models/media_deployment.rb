class MediaDeployment < ActiveRecord::Base
  has_paper_trail
  belongs_to :media_item
  belongs_to :playlist
  
  validates :playlist_position, :media_item, :playlist, presence: true
  validates_inclusion_of :playlist_position, :in => -1000000..1000000
  
  rails_admin do
    visible false
  end
  
  def to_s
    "#{media_item.to_s} @ #{playlist.to_s}"
  end
  
end
