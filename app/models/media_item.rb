require 'csv'

class MediaItem < ApplicationRecord
  self.inheritance_column = 'sti_type'

  has_many :playlist_items, inverse_of: :media_item, class_name: 'Playlist::Item', dependent: :destroy
  has_many :playlists, -> { distinct }, through: :playlist_items
  belongs_to :company, inverse_of: :media_items
  has_many :taggings, as: :taggable, dependent: :destroy
  has_many :tags, through: :taggings

  enum type: %w[background advertising]
  enum library: %w[personal standard premium]

  has_one_attached :file

  attr_accessor :skip_file_validation # HACK: for validation in controller
  validates :file, presence: true, unless: -> { skip_file_validation }
  validates :company, presence: true
  validates :description, length: { maximum: 130 }

  scope :search_query, ->(query) {
    q = "%#{query}%"
    joins(:file_attachment, :file_blob).where('LOWER(active_storage_blobs.filename) LIKE LOWER(?) OR LOWER(media_items.description) LIKE LOWER(?)', q, q)
  }
  scope :with_company_id, ->(companies_ids) { where(company_id: [*companies_ids]) }
  scope :with_tag_ids, ->(tag_ids) { left_outer_joins(:tags).where(tags: { id: tag_ids }) }
  scope :with_type, ->(type) { where(type: types[type]) }
  scope :with_library, ->(lib) { lib == 'all' ? all : where(library: libraries[lib]) }
  scope :without_playlist, -> { includes(:playlist_items).where(playlist_items: { media_item_id: nil }) }

  class << self
    def to_csv(filepath:, scope: all)
      CSV.open(filepath, 'wb') do |csv|
        csv << %w[name description type library tags company]
        scope.includes(:tags, :company).with_attached_file.find_each do |i|
          csv << [i.file_name, i.description, i.type, i.library, i.tags.pluck(:name).join(','), i.company.to_s]
        end
      end
    end
  end

  def size
    file.blob.byte_size
  end

  def file_name
    file.filename.to_s
  end

  # rubocop: disable Rails/Delegate
  def content_type
    file.content_type
  end
  # rubocop: enable Rails/Delegate

  def file_url
    Rails.application.routes.url_helpers.rails_blob_path(file, only_path: true)
  end

  def to_s
    result = file_name.dup
    result << " (#{description})" if description.present?
    result << " in #{company}" if company
    result
  end

  def serialize
    item = attributes
    item['file'] = file.filename.base
    item['file_url'] = file_url
    item['file_content_type'] = content_type
    item['tags'] = tags.map(&:serialize)
    item['company'] = company.serialize
    item
  end
end
