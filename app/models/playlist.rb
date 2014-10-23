require 'tempfile'

class Playlist < ActiveRecord::Base
  
  has_many :media_deployments 
  has_many :media_items, :through => :media_deployments
  has_many :devices
  
  validates :name, presence: true
  
  before_save :create_playlist_file
  
  mount_uploader :file, PlaylistFileUploader
  
  private
    def create_playlist_file
      if !media_items.empty?
        tempfile = Tempfile.new(['playlist', '.m3u'])
        self.media_deployments.order(:playlist_position).each do |deployment|
          tempfile.puts deployment.media_item.file_identifier
        end
        tempfile.close
        self.file = tempfile
        tempfile.unlink
      end
    end
  
end
