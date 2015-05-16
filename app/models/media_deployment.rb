class MediaDeployment < ActiveRecord::Base
  has_paper_trail
  belongs_to :media_item
  belongs_to :playlist
  
  validates :playlist_position, :media_item, :playlist, presence: true
  validates_inclusion_of :playlist_position, :in => -1000000..1000000
  
  validate :check_files_processing
  
  rails_admin do
    visible false
  end
  
  def to_s
    "#{media_item.to_s} @ #{playlist.to_s}"
  end
  
  private
  
    def check_files_processing
      if media_item.file.video? && media_item.file_processing?
        errors.add(:media_item, I18n.t(:file_processing))
        false
      else
        true     
      end
    end
  
end
