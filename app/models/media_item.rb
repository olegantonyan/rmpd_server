class MediaItem < ActiveRecord::Base
  has_paper_trail
  has_many :media_deployments
  has_many :playlists, :through => :media_deployments
  
  mount_uploader :file, MediaItemUploader
  
  validates_presence_of :file
  validates_length_of :description, :maximum => 130
  
  scope :in_playlist_ordered, ->(playlist_id) { joins(:media_deployments).
    where(:media_deployments => {:playlist => playlist_id}).order('media_deployments.playlist_position') }
    
    
  rails_admin do 
    object_label_method do
      :custom_label_method
    end
  end
  
  private
  
    def custom_label_method
      file_identifier
    end
  
end
