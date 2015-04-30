class MediaDeployment < ActiveRecord::Base
  has_paper_trail
  belongs_to :media_item
  belongs_to :playlist
  
  validates_presence_of :playlist_position
  validates_inclusion_of :playlist_position, :in => -1000000..1000000
  
  rails_admin do
    visible false
  end
  
end
