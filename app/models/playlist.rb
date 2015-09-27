require 'tempfile'

class Playlist < ActiveRecord::Base
  has_paper_trail

  has_many :playlist_items, -> {
    order(:position)
    }, dependent: :destroy, autosave: true, inverse_of: :playlist, class_name: Playlist::Item
  has_many :media_items, -> {
    joins(:playlist_items).order('playlist_items.position').group('media_items.id, playlist_items.position')
    }, through: :playlist_items, autosave: true
  has_many :devices, inverse_of: :playlist
  belongs_to :company, inverse_of: :playlists

  after_save :playlist_updated
  after_destroy :playlist_destroyed

  mount_uploader :file, PlaylistFileUploader

  validates_presence_of :name
  validates_length_of :name, :maximum => 130
  validates_length_of :description, :maximum => 250
  validates_presence_of :playlist_items
  #validates_presence_of :media_items
  validate :check_files_processing

  def deploy_media_items!(items, media_items_positions)
    playlist_items.destroy_all
    items.each do |i|
      position = media_items_positions.find{ |e| e.first.to_i == i.id}.second
      playlist_items << Playlist::Item.create(:media_item => i, :position => position, :playlist => self)
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
      exclude_fields :playlist_items, :versions
    end
    edit do
      exclude_fields :playlist_items, :versions, :file
    end
  end

  def to_s
    (description.blank? ? "#{name}" : "#{name} (#{description})") + " in #{company.to_s}"
  end

  private
    def create_playlist_file
      tempfile = Tempfile.new(['playlist', '.m3u'])
      self.playlist_items.includes(:media_item).each do |deployment| #TODO fix problem with join in association
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

    def check_files_processing
      if playlist_items.find{|i| !i.valid? }
        errors.add(:base, I18n.t(:files_processing)) # for error message only
        false
      else
        true
      end
    end

end
