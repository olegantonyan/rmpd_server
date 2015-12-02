class MediaItem < ActiveRecord::Base
  self.inheritance_column = 'sti_type'

  include ScopesWithUser
  has_paper_trail

  has_many :playlist_items, dependent: :destroy, inverse_of: :media_item, class_name: 'Playlist::Item'
  has_many :playlists, through: :playlist_items
  belongs_to :company, inverse_of: :media_items

  enum type: %w(background advertising)

  mount_uploader :file, MediaItemUploader
  process_in_background :file

  validates :file, presence: true
  validates :description, length: { maximum: 130 }

  filterrific(
    available_filters: [:search_query, :with_company_id]
  )

  scope :search_query, -> (query) {
    q = "%#{UnicodeUtils.downcase query.to_s}%"
    where('LOWER(file) LIKE ? OR LOWER(description) LIKE ?', q, q)
  }

  scope :with_company_id, -> (companies_ids) {
    where(company_id: [*companies_ids])
  }

  rails_admin do
    object_label_method do
      :custom_label_method
    end
    list do
      field :file
      field :description
      field :company
      field :playlists
    end
    show do
      exclude_fields :playlist_items, :versions
    end
    edit do
      exclude_fields :playlist_items, :versions
    end
  end

  def to_s
    "#{file_identifier} in #{company}"
  end

  def self.type_options_for_select
    types.map { |k, _| [I18n.t("activerecord.attributes.media_item.types.#{k}"), k] }
  end

  private

  def custom_label_method
    file_identifier
  end
end
