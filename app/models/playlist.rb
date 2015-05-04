require 'tempfile'

class Playlist < ActiveRecord::Base
  has_paper_trail
  has_many :media_deployments, :dependent => :destroy
  has_many :media_items, -> { joins(:media_deployments).order('media_deployments.playlist_position').group('media_items.id') }, :through => :media_deployments
  has_many :devices
  belongs_to :company
  
  after_save :playlist_updated
  after_destroy :playlist_destroyed
  
  mount_uploader :file, PlaylistFileUploader
  
  validates_presence_of :name
  validates_length_of :name, :maximum => 130
  validates_length_of :description, :maximum => 250
  validates_presence_of :media_deployments
  #validates_presence_of :media_items
  
  def deploy_media_items!(media_items, media_items_positions)
    media_deployments.clear
    media_items.each do |i|
      playlist_position = media_items_positions.find{ |e| e.first.to_i == i.id}.second 
      media_deployments << MediaDeployment.new(:media_item => i, :playlist_position => playlist_position)
    end
  end
  
  rails_admin do 
    list do
      field :name
      field :description
      field :company
      field :created_at
      field :updated_at
    end
    show do
      exclude_fields :media_deployments, :versions
    end
    edit do
      exclude_fields :media_deployments, :versions, :file
    end
  end
  
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
