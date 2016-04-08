require 'rails_helper'

RSpec.describe Device::Group, type: :model do
  it { expect(build(:device_group)).to be_valid }

  describe 'validations' do
    it { expect(build(:device_group, title: nil)).to be_invalid }
  end
end
