class MediaDeployment < ActiveRecord::Base
  
  belongs_to :media_item
  belongs_to :playlist
  
  validates_presence_of :playlist_position
  validates_inclusion_of :playlist_position, :in => -1000000..1000000
  
end
