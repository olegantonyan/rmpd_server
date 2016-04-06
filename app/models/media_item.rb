class MediaItem < ApplicationRecord
  self.inheritance_column = 'sti_type'

  has_many :playlist_items, dependent: :destroy, inverse_of: :media_item, class_name: 'Playlist::Item'
  has_many :playlists, through: :playlist_items
  belongs_to :company, inverse_of: :media_items

  enum type: %w(background advertising)

  mount_uploader :file, MediaItemUploader
  process_in_background :file

  validates :file, presence: true
  validates :description, length: { maximum: 130 }

  filterrific(available_filters: %i(search_query with_company_id with_type))

  scope :search_query, -> (query) {
    q = "%#{query}%"
    where('LOWER(file) LIKE LOWER(?) OR LOWER(description) LIKE LOWER(?)', q, q)
  }
  scope :with_company_id, -> (companies_ids) { where(company_id: [*companies_ids]) }
  scope :with_type, -> (type) { where(type: types[type]) }

  delegate :path, to: :file, prefix: true

  def to_s
    "#{file_identifier} in #{company}"
  end

  def self.human_enum_name(enum_key)
    I18n.t("activerecord.attributes.media_item.types.#{enum_key}")
  end

  def duration
    @_duration ||= MediafilesUtils.duration(file.path)
  end
end
