class Device::ServiceUpload < ApplicationRecord
  has_paper_trail

  belongs_to :device, inverse_of: :device_service_uploads

  mount_uploader :file, ServiceUploadUploader

  validates :file, presence: true

  def request
    return false unless device
    device.send_to(:request_service_upload)
  end

  # def generate_filename
  #   cv = device.client_version
  #   "#{reason}-#{cv.rmpd}-#{cv.version}-#{Time.current.to_formatted_s(:rmpd_custom_date_time)}"
  # end
end
