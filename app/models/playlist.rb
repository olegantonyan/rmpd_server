require 'tempfile'

class Playlist < ActiveRecord::Base
  has_paper_trail
  has_many :media_deployments, :dependent => :destroy
  has_many :media_items, :through => :media_deployments
  has_many :devices
  
  after_save :playlist_updated
  after_destroy :playlist_destroyed
  
  mount_uploader :file, PlaylistFileUploader
  
  validates_presence_of :name
  validates_length_of :name, :maximum => 130
  validates_length_of :description, :maximum => 250
  validates_presence_of :media_deployments
  
  private
    def create_playlist_file
      tempfile = Tempfile.new(['playlist', '.m3u'])
      self.media_deployments.includes(:media_item).order(:playlist_position).each do |deployment|
        tempfile.puts deployment.media_item.file_identifier
      end
      tempfile.close
      self.file = tempfile
      tempfile.unlink
    end
    
    def playlist_updated
      create_playlist_file
      Playlist.skip_callback(:save, :after, :playlist_updated) # skipping callback is required to prevent recursion 
      save  # save newly created file in db
      Playlist.set_callback(:save, :after, :playlist_updated) 
      
      self.devices.each do |d|
        Deviceapi::Protocol.new.update_playlist d
      end
    end
    
    def playlist_destroyed
      self.devices.each do |d|
        Deviceapi::Protocol.new.delete_playlist d
      end
    end
  
end
