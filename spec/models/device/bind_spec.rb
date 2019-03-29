require 'rails_helper'

RSpec.describe Device::Bind, type: :model do
  describe 'validations' do
    it { expect(build(:device_bind, login: nil)).to be_invalid }
    it { expect(build(:device_bind, company_id: nil)).to be_invalid }

    it do
      company = create(:company)
      device = create(:device, company: nil)
      expect(build(:device_bind, company_id: company.id, login: device.login)).to be_valid
    end

    it do
      company = create(:company)
      device = create(:device)
      expect(build(:device_bind, company_id: company.id, login: device.login)).to be_invalid
    end

    it do
      company = create(:company)
      expect(build(:device_bind, company_id: company.id, login: SecureRandom.hex)).to be_invalid
    end
  end

  it do
    company = create(:company)
    device = create(:device, company: nil)
    bind = build(:device_bind, company_id: company.id, login: device.login)
    expect(bind).to be_valid
    bind.save
    device.reload
    expect(device.company).to eq company
  end
end
