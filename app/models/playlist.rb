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
      self.media_deployments.each { |d| d.save }
      tempfile = Tempfile.new(['playlist', '.m3u'])
      self.media_deployments.order(:playlist_position).each do |deployment|
        tempfile.puts deployment.media_item.file_identifier
      end
      tempfile.close
      self.file = tempfile
      tempfile.unlink
    end
    
    def playlist_updated
      self.devices.each do |d|
        #puts "******************\n\n"
        #puts "playlist by device: " + d.playlist.inspect + " url " + d.playlist.file_url + " new_record?" + d.playlist.new_record?.to_s
        #pp = Playlist.where("device_id" == d.id).first
        #puts "playlist found: " + pp.inspect + " url " + pp.file_url + " new_record?" + pp.new_record?.to_s
        #puts "******************\n\n"
        RemoteProtocol.new.update_playlist d
      end
    end
    
    def playlist_destroyed
      self.devices.each do |d|
        RemoteProtocol.new.delete_playlist d
      end
    end
  
end
