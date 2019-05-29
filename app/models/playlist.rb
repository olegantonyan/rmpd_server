class Playlist < ApplicationRecord
  has_many :devices, inverse_of: :playlist, dependent: :nullify

  has_many :playlist_items_background,
           -> { background.order(:position) },
           class_name: 'Playlist::Item::Background',
           foreign_key: :playlist_id,
           dependent: :destroy,
           inverse_of: :playlist

  has_many :playlist_items_advertising,
           -> { advertising },
           class_name: 'Playlist::Item::Advertising',
           foreign_key: :playlist_id,
           dependent: :destroy,
           inverse_of: :playlist

  has_many :playlist_items, class_name: 'Playlist::Item', dependent: :destroy
  has_many :media_items, -> { distinct }, through: :playlist_items
  belongs_to :company, inverse_of: :playlists

  validates :name, presence: true, length: { maximum: 128 }
  validates :description, length: { maximum: 512 }

  scope :search_query, ->(query) {
    q = "%#{query}%"
    where('LOWER(name) LIKE LOWER(?) OR LOWER(description) LIKE LOWER(?)', q, q)
  }
  scope :with_company_id, ->(companies_ids) { where(company_id: [*companies_ids]) }
  scope :without_device, -> { includes(:devices).where(devices: { playlist_id: nil }) }

  def media_items_count # rubocop: disable Rails/Delegate
    media_items.count
  end

  def to_s
    (description.blank? ? name : "#{name} (#{description})")
  end

  def schedule
    @schedule ||= AdSchedule::Scheduler.new(playlist_items_advertising.includes(:media_item))
  end

  def total_size
    media_items.with_attached_file.sum('active_storage_blobs.byte_size').to_i
  end

  def destroy_and_remove_from_devices
    transaction do
      devices.each do |d|
        Playlist::Assign.new(assignable: d, playlist_id: nil, force: true).call
      end
      destroy
    end
  end

  def serialize(with_items: false)
    i = attributes.slice('id', 'name', 'description', 'created_at', 'updated_at')
    i['company'] = company.serialize
    i['items_count'] = media_items_count
    i['items_size'] = total_size
    i['devices_count'] = devices.count
    i['playlist_items'] = playlist_items.includes(media_item: [:company, { file_attachment: :blob }, :tags]).map(&:serialize) if with_items
    i
  end
end
