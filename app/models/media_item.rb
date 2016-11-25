class MediaItem < ApplicationRecord
  include UploadableModel

  self.inheritance_column = 'sti_type'

  attr_accessor :skip_file_processing, :skip_volume_normalization # candidate for service extraction

  has_paper_trail

  has_many :playlist_items, inverse_of: :media_item, class_name: 'Playlist::Item'
  has_many :playlists, -> { distinct }, through: :playlist_items
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

  filterrific(available_filters: %i(search_query with_company_id with_type with_file_processing))

  scope :search_query, ->(query) {
    q = "%#{query}%"
    where('LOWER(file) LIKE LOWER(?) OR LOWER(description) LIKE LOWER(?)', q, q)
  }
  scope :with_company_id, ->(companies_ids) { where(company_id: [*companies_ids]) }
  scope :with_type, ->(type) { where(type: types[type]) }
  scope :with_file_processing, ->(state) { where(file_processing: state) }
  scope :processing, -> { where(file_processing: true) }
  scope :not_processing, -> { where(file_processing: false) }
  scope :failed, -> { where.not(file_processing_failed_message: nil) }
  scope :successfull, -> { where(file_processing_failed_message: nil) }
  scope :without_playlist, -> { includes(:playlist_items).where(playlist_items: { media_item_id: nil }) }

  with_options to: :file do
    delegate :path, prefix: true
    with_options allow_nil: true do
      delegate :content_type
      delegate :size
    end
  end

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
    @_duration ||= begin
      if image?
        Duration.new
      else
        MediafilesUtils.duration(file.path)
      end
    end
  end

  def image?
    content_type.starts_with? 'image/'
  end

  def video?
    content_type.starts_with? 'video/'
  end

  def audio?
    content_type.starts_with? 'audio/'
  end

  def file_processing_failed!(message)
    update(file_processing_failed_message: message)
  end

  def file_processing_failed?
    !file_processing_failed_message.nil?
  end

  def rename_file_attribute!(new_name)
    self.class.where(self.class.primary_key => id).limit(1).update_all(file: new_name)
    reload
  end

  private

  def process_file
    MediaItemProcessingWorker.perform_async(id, skip_volume_normalization)
  end

  def mark_file_processing
    self.file_processing = true
  end
end
