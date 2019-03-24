class Device
  class SoftwareUpdate < ApplicationRecord
    belongs_to :device

    validates :version, presence: true
    validates :file, presence: true
    validate :supported

    scope :ordered, -> { order(created_at: :desc) }

    def file=(rack_file)
      return unless rack_file
      super(rack_file.read)
    end

    private

    def supported
      errors.add(:base, 'unsupported device') unless device&.client_version&.self_update_support?
    end
  end
end
