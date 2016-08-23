require 'rails_helper'

RSpec.describe Device::ServiceUpload, type: :model do
  it { expect(build(:device_service_upload)).to be_valid }

  describe 'validations' do
    it { expect(build(:device_service_upload, file: nil)).to be_invalid }
  end
end
