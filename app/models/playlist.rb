require 'tempfile'

class Playlist < ActiveRecord::Base
  
  has_many :media_deployments 
  has_many :media_items, :through => :media_deployments
  has_many :devices
  
  validates :name, presence: true
  
  after_save :playlist_updated
  after_destroy :playlist_destroyed
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
    
    def playlist_updated
      self.devices.each do |d|
        RemoteProtocol.new.update_playlist d
      end
    end
    
    def playlist_destroyed
      self.devices.each do |d|
        RemoteProtocol.new.delete_playlist d
      end
    end
  
end
