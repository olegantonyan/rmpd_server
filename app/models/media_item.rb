class MediaItem < ApplicationRecord
  include UploadableModel
  include Taggable

  self.inheritance_column = 'sti_type'

  attr_accessor :skip_file_processing, :skip_volume_normalization # candidate for service extraction

  has_paper_trail

  has_many :playlist_items, inverse_of: :media_item, class_name: 'Playlist::Item'
  has_many :playlists, -> { distinct }, through: :playlist_items
  belongs_to :company, inverse_of: :media_items

  enum type: %w[background advertising]

  mount_uploader :file, MediaItemUploader
  with_options unless: :skip_file_processing do
    before_create :mark_file_processing
    after_commit :process_file, on: :create
  end
  before_save :cache_duration

  with_options presence: true do
    validates :file
    validates :company
  end
  validates :description, length: { maximum: 130 }

  filterrific(available_filters: %i[search_query with_company_id with_type with_file_processing with_tag_id])

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
  scope :all_with_tag_names, -> {
    qry = select("STRING_AGG(tags.name,  ', ') AS tag_names, companies.title AS company_title, media_items.*")
          .joins("FULL OUTER JOIN taggings ON taggings.taggable_id = media_items.id AND taggings.taggable_type = '#{sanitize_sql_for_conditions(name)}'")
          .joins('FULL OUTER JOIN tags ON tags.id = taggings.tag_id')
          .joins('LEFT JOIN companies ON media_items.company_id = companies.id')
          .group('media_items.id, companies.id')
    def qry.count
      except(:select, :group, :joins).count
    end
    qry
  }

  with_options to: :file do
    delegate :path, prefix: true
    with_options allow_nil: true do
      delegate :size
    end
  end

  def to_s # rubocop: disable Metrics/AbcSize
    result = file_identifier.dup
    result << " (#{description})" if description.present?
    result << " in #{company}" if company
    result << " [#{tags.pluck(:name).join(', ')}]" if tags.exists?
    result
  end

  def to_s_tag_names_query
    result = file_identifier.dup
    result << " (#{description})" if description.present?
    result << " in #{company_title}" if company_title.present?
    result << " [#{tag_names}]" if tag_names.present?
    result
  end

  def self.human_enum_name(enum_key)
    I18n.t("activerecord.attributes.media_item.types.#{enum_key}", default: enum_key.to_s.titleize)
  end

  def content_type
    file&.content_type&.gsub('application/mp4', 'video/mp4') # broke after update to rails 5.0.1
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

  # rubocop: disable Rails/SkipsModelValidations
  def rename_file_attribute!(new_name)
    self.class.where(self.class.primary_key => id).limit(1).update_all(file: new_name)
    reload
  end
  # rubocop: enable Rails/SkipsModelValidations

  private

  def process_file
    MediaItemProcessingWorker.perform_async(id, skip_volume_normalization)
  end

  def mark_file_processing
    self.file_processing = true
  end

  def cache_duration
    self.duration = image? ? 0 : MediafilesUtils.duration(file.path)
  end
end
