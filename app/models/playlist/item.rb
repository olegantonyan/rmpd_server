class Playlist::Item < ActiveRecord::Base
  has_paper_trail

  with_options inverse_of: :playlist_items do |a|
    a.belongs_to :media_item
    a.belongs_to :playlist
  end

  with_options presence: true do
    validates :media_item
    validates :playlist
  end
  validate :check_files_processing

  scope :background, -> { joins(:media_item).where('media_items.type = ?', MediaItem.types['background']) }
  scope :advertising, -> { joins(:media_item).where('media_items.type = ?', MediaItem.types['advertising']) }

  delegate :file_url, :type, :description, :file_identifier, to: :media_item

  rails_admin do
    visible false
  end

  def to_s
    "#{media_item.to_s} @ #{playlist.to_s}"
  end

  private

  def check_files_processing
    if media_item.file.video? && media_item.file_processing?
      errors.add(:media_item, I18n.t('activerecord.attributes.media_item.file_processing'))
    end
  end

end
