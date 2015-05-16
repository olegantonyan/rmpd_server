require 'tempfile'

class Playlist < ActiveRecord::Base
  has_paper_trail
  has_many :media_deployments, dependent: :destroy, autosave: true
  has_many :media_items, -> { 
    joins(:media_deployments).order('media_deployments.playlist_position').group('media_items.id, media_deployments.playlist_position') 
    }, through: :media_deployments, autosave: true
    
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
  validate :check_files_processing
  
  def deploy_media_items!(items, media_items_positions)
    media_deployments.destroy_all
    items.each do |i|
      playlist_position = media_items_positions.find{ |e| e.first.to_i == i.id}.second 
      media_deployments << MediaDeployment.create(:media_item => i, :playlist_position => playlist_position)
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
  
  def to_s
    (description.blank? ? "#{name}" : "#{name} (#{description})") + " in #{company.to_s}"
  end
  
  private
    def create_playlist_file
      tempfile = Tempfile.new(['playlist', '.m3u'])
      self.media_items.each do |item|
        tempfile.puts item.file_identifier
      end
      tempfile.close
      self.file = tempfile
      tempfile.unlink
    end
    
    def playlist_updated
      
      Playlist.skip_callback(:save, :after, :playlist_updated) # skipping callback is required to prevent recursion 
      save  # save newly created file in db
      create_playlist_file
      save
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
    
    def check_files_processing
      if media_deployments.find{|i| !i.valid? }
        errors.add(:base, I18n.t(:files_processing)) # for error message only
        false
      else
        true    
      end
    end
  
end
