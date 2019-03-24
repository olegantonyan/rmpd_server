class Device
  class SoftwareUpdate < ApplicationRecord
    belongs_to :device

    validates :version, presence: true
    validates :file, presence: true
    validate :supported

    scope :ordered, -> { order(created_at: :desc) }

    def file=(rack_file)
      return unless rack_file
      filename = "#{rack_file.original_filename}_#{SecureRandom.hex}"
      filepath = Rails.root.join('public', 'uploads', 'software_update')
      FileUtils.mkdir_p(filepath)
      File.open(filepath.join(filename), 'wb') { |f| f.write(rack_file.read) }
      super(filename)
    end

    def file_path
      File.join('uploads', 'software_update', file)
    end

    def file_url(base_url)
      URI.join(base_url, file_path).to_s
    end

    private

    def supported
      errors.add(:base, 'unsupported device') unless device&.client_version&.self_update_support?
    end
  end
end
