require 'rails_helper'

RSpec.describe Device::Group::Membership, type: :model do
  it { expect(build(:device_group_membership)).to be_valid }

  describe 'validations' do
    it { expect(build(:device_group_membership, device: nil)).to be_invalid }
    it { expect(build(:device_group_membership, device_group: nil)).to be_invalid }
  end
end
