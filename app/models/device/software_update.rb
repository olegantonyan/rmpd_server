class Device
  class SoftwareUpdate < ApplicationRecord
    belongs_to :device

    validates :version, presence: true
    validates :file, presence: true
    validate :supported

    has_one_attached :file

    scope :ordered, -> { order(created_at: :desc) }

    def file_url
      Rails.application.routes.url_helpers.rails_blob_path(file, only_path: true)
    end

    private

    def supported
      errors.add(:base, 'unsupported device') unless device&.client_version&.self_update_support?
    end
  end
end
