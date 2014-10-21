class MediaItem < ActiveRecord::Base
  
  has_many :media_deployments
  has_many :playlists, :through => :media_deployments
  
  mount_uploader :file, MediaItemUploader
  
  scope :in_playlist_ordered, ->(playlist_id) { joins(:media_deployments).
    where(:media_deployments => {:playlist => playlist_id}).order('media_deployments.playlist_position') }
  
end
