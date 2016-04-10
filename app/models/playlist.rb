class Playlist < ApplicationRecord
  include ValidatesHasManyWithErrorMessages

  has_paper_trail

  with_options inverse_of: :playlist do |a|
    a.has_many :playlist_items, -> { order(:position) }, dependent: :destroy, class_name: 'Playlist::Item'
    a.has_many :devices
  end
  with_options foreign_key: :playlist_id do |a|
    a.has_many :playlist_items_background, -> { background.order(:position) }, class_name: 'Playlist::Item::Background'
    a.has_many :playlist_items_advertising, -> { advertising }, class_name: 'Playlist::Item::Advertising'
  end
  has_many :media_items, -> { joins(:playlist_items).order('playlist_items.position').group('media_items.id, playlist_items.position') },
           through: :playlist_items
  belongs_to :company, inverse_of: :playlists

  after_save :store_file
  # after_save :update_schedule
  after_commit :notify_devices_delete, on: :destroy
  after_commit :notify_devices_update, on: %i(create update)

  mount_uploader :file, PlaylistFileUploader

  with_options presence: true do
    validates :name, length: { maximum: 128 }
    validates :playlist_items
  end
  validates :description, length: { maximum: 512 }
  validates_has_many_with_error_messages :playlist_items
  validate :overlapped_schedule

  filterrific(available_filters: %i(search_query with_company_id))

  scope :search_query, -> (query) {
    q = "%#{query}%"
    where('LOWER(name) LIKE LOWER(?) OR LOWER(description) LIKE LOWER(?)', q, q)
  }
  scope :with_company_id, -> (companies_ids) { where(company_id: [*companies_ids]) }

  accepts_nested_attributes_for :playlist_items_background, allow_destroy: true, reject_if: :all_blank
  accepts_nested_attributes_for :playlist_items_advertising, allow_destroy: true, reject_if: :all_blank

  def to_s
    (description.blank? ? name : "#{name} (#{description})")
  end

  def schedule
    @_schedule ||= Schedule::Scheduler.new(playlist_items.includes(:media_item).advertising)
  end

  def files_processing
    media_items.processing
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
