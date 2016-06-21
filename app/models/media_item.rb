class MediaItem < ApplicationRecord
  self.inheritance_column = 'sti_type'

  attr_accessor :skip_file_processing

  has_paper_trail

  has_many :playlist_items, dependent: :destroy, inverse_of: :media_item, class_name: 'Playlist::Item'
  has_many :playlists, through: :playlist_items
  belongs_to :company, inverse_of: :media_items

  enum type: %w(background advertising)

  mount_uploader :file, MediaItemUploader
  with_options unless: :skip_file_processing do
    before_create :mark_file_processing
    after_commit :process_file, on: :create
  end

  with_options presence: true do
    validates :file
    validates :company
  end
  validates :description, length: { maximum: 130 }

  filterrific(available_filters: %i(search_query with_company_id with_type))

  scope :search_query, -> (query) {
    q = "%#{query}%"
    where('LOWER(file) LIKE LOWER(?) OR LOWER(description) LIKE LOWER(?)', q, q)
  }
  scope :with_company_id, -> (companies_ids) { where(company_id: [*companies_ids]) }
  scope :with_type, -> (type) { where(type: types[type]) }
  scope :processing, -> { where(file_processing: true) }
  scope :not_processing, -> { where(file_processing: false) }
  scope :without_playlist, -> { includes(:playlist_items).where(playlist_items: { media_item_id: nil }) }

  delegate :path, to: :file, prefix: true

  def to_s
    if description.blank?
      "#{file_identifier} in #{company}"
    else
      "#{file_identifier} (#{description}) in #{company}"
    end
  end

  def self.human_enum_name(enum_key)
    I18n.t("activerecord.attributes.media_item.types.#{enum_key}", default: enum_key.to_s.titleize)
  end

  def duration
    @_duration ||= MediafilesUtils.duration(file.path)
  end

  private

  def process_file
    MediaItemProcessingJob.perform_later(self)
  end

  def mark_file_processing
    self.file_processing = true
  end
end
