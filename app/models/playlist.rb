require 'schedule/scheduler'
require 'schedule/item'

class Playlist < ApplicationRecord
  include PlaylistLegacy

  has_paper_trail

  with_options inverse_of: :playlist do |a|
    a.has_many :devices
    a.with_options foreign_key: :playlist_id, dependent: :destroy, after_add: :append_added_playlist_item do |aa|
      aa.has_many :playlist_items_background, -> { background.order(:position) }, class_name: 'Playlist::Item::Background'
      aa.has_many :playlist_items_advertising, -> { advertising }, class_name: 'Playlist::Item::Advertising'
    end
  end
  has_many :playlist_items, class_name: 'Playlist::Item'
  has_many :media_items, -> { joins(:playlist_items).order('playlist_items.position').group('media_items.id, playlist_items.position') },
           through: :playlist_items
  belongs_to :company, inverse_of: :playlists

  validates :name, presence: true, length: { maximum: 128 }
  validates :description, length: { maximum: 512 }

  with_options allow_destroy: true, reject_if: :all_blank do
    accepts_nested_attributes_for :playlist_items_background
    accepts_nested_attributes_for :playlist_items_advertising
  end

  filterrific(available_filters: %i(search_query with_company_id))

  scope :search_query, -> (query) {
    q = "%#{query}%"
    where('LOWER(name) LIKE LOWER(?) OR LOWER(description) LIKE LOWER(?)', q, q)
  }
  scope :with_company_id, -> (companies_ids) { where(company_id: [*companies_ids]) }
  scope :without_device, -> { includes(:devices).where(devices: { playlist_id: nil }) }

  attr_accessor :wait_for_the_end

  def uniq_media_items
    media_items.distinct
  end

  def to_s
    (description.blank? ? name : "#{name} (#{description})")
  end

  def schedule
    @_schedule ||= Schedule::Scheduler.new(playlist_items_advertising.includes(:media_item))
  end

  def files_processing
    media_items.processing
  end

  def total_size
    uniq_media_items.inject(0) { |a, e| a + e.file.size.to_i }
  end

  def added_playlist_items
    @_added_playlist_items || []
  end

  def wait_for_the_end
    playlist_items_background.where(wait_for_the_end: true).exists?
  end

  private

  def append_added_playlist_item(item)
    @_added_playlist_items ||= []
    @_added_playlist_items << item
  end
end
