class Playlist < ApplicationRecord
  include PlaylistItemsCreation
  include ValidatesHasManyWithErrorMessages

  with_options inverse_of: :playlist do |a|
    a.has_many :playlist_items, -> { order(:position) }, dependent: :destroy, class_name: 'Playlist::Item'
    a.has_many :devices
  end
  has_many :media_items, -> { joins(:playlist_items).order('playlist_items.position').group('media_items.id, playlist_items.position') },
           through: :playlist_items
  belongs_to :company, inverse_of: :playlists

  after_save :store_file
  after_save :update_schedule
  after_commit :notify_devices_delete, on: :destroy
  after_commit :notify_devices_update, on: [:create, :update]

  mount_uploader :file, PlaylistFileUploader

  with_options presence: true do
    validates :name, length: { maximum: 128 }
    validates :playlist_items
  end
  validates :description, length: { maximum: 512 }
  validates_has_many_with_error_messages :playlist_items
  validate :overlapped_schedule

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
    (description.blank? ? name : "#{name} (#{description})") + " in #{company}"
  end

  def schedule
    @_schedule ||= Schedule::Scheduler.new(playlist_items.includes(:media_item).advertising)
  end

  private

  def create_playlist_file
    tempfile = Tempfile.new(['playlist', '.m3u'])
    playlist_items.includes(:media_item).each do |deployment| # TODO: fix problem with join in association
      tempfile.puts deployment.media_item.file_identifier
    end
    tempfile.close
    self.file = tempfile
    tempfile.unlink
  end

  def store_file
    create_playlist_file
    Playlist.skip_callback(:save, :after, :store_file) # skipping callback is required to prevent recursion
    save # save newly created file in db
    Playlist.set_callback(:save, :after, :store_file)
  end

  def notify_devices_update
    devices.each { |d| d.send_to :update_playlist }
  end

  def notify_devices_delete
    devices.each { |d| d.send_to :delete_playlist }
  end

  def overlapped_schedule
    errors.add(:base, "advertising schedule overlap: #{schedule.overlap.map(&:file_identifier).to_sentence}") if schedule.overlap
  end

  def update_schedule
    playlist_items.advertising.each do |pitem|
      pitem.schedule = schedule.items.find { |i| i.id == pitem.id }.schedule_times
      pitem.save!
    end
  end
end
