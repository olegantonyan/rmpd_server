class MediaItem < ActiveRecord::Base
  
  has_many :media_deployments
  has_many :playlists, :through => :media_deployments
  
  mount_uploader :file, MediaItemUploader
  
end
