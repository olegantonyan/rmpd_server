class Playlist < ActiveRecord::Base
  include Playlist::ItemsCreation
  include ValidatesHasManyWithErrorMessages
  has_paper_trail

  with_options inverse_of: :playlist do |a|
    a.has_many :playlist_items, -> { order(:position) }, dependent: :destroy, class_name: Playlist::Item
    a.has_many :devices
  end
  has_many :media_items, -> { joins(:playlist_items).order('playlist_items.position').group('media_items.id, playlist_items.position') }, through: :playlist_items
  belongs_to :company, inverse_of: :playlists

  after_save :playlist_updated
  after_destroy :playlist_destroyed

  mount_uploader :file, PlaylistFileUploader

  with_options presence: true do
    validates :name, length: {maximum: 128}
    validates :playlist_items
  end
  validates :description, length: {maximum: 512}
  validates_has_many_with_error_messages :playlist_items

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

    devices.each { |d| d.send_to :update_playlist }
  end

  def playlist_destroyed
    devices.each { |d| d.send_to :delete_playlist }
  end

end
