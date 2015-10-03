class Playlist::Item < ActiveRecord::Base
  has_paper_trail

  with_options inverse_of: :playlist_items do
    belongs_to :media_item
    belongs_to :playlist
  end

  validates :position, :media_item, :playlist, presence: true
  validates_inclusion_of :position, :in => -1000000..1000000

  validate :check_files_processing

  scope :background, -> { joins(:media_item).where('media_items.type = ?', MediaItem.types['background']) }
  scope :advertising, -> { joins(:media_item).where('media_items.type = ?', MediaItem.types['advertising']) }

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
        false
      else
        true
      end
    end

end
