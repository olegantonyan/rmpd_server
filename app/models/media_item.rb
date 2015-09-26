class MediaItem < ActiveRecord::Base
  has_paper_trail

  has_many :media_deployments, dependent: :destroy, inverse_of: :media_item
  has_many :playlists, through: :media_deployments
  belongs_to :company, inverse_of: :media_items

  mount_uploader :file, MediaItemUploader
  process_in_background :file

  validates_presence_of :file
  validates_length_of :description, :maximum => 130

  filterrific(
    available_filters: [ :search_query, :with_company_id ]
  )

  scope :search_query, ->(query) {
    q = "%#{UnicodeUtils.downcase query.to_s}%"
    where('LOWER(file) LIKE ? OR LOWER(description) LIKE ?', q, q)
  }

  scope :with_company_id, ->(companies_ids) {
    where(:company_id => [*companies_ids])
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
      exclude_fields :media_deployments, :versions
    end
    edit do
      exclude_fields :media_deployments, :versions
    end
  end

  def to_s
    "#{file_identifier} in #{company.to_s}"
  end

  private

    def custom_label_method
      file_identifier
    end

end
