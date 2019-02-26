class Device
  class ServiceUpload < ApplicationRecord
    belongs_to :device, inverse_of: :device_service_uploads

    mount_uploader :file, ServiceUploadUploader

    validates :file, presence: true

    after_commit :notify, on: :create

    def request
      return false unless device
      device.send_to(:request_service_upload)
    end

    private

    def notify
      Notifiers::ServiceUploadNotifierJob.perform_later(device)
    end
  end
end
