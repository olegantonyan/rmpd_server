require 'rails_helper'

RSpec.describe Device, type: :model do
  it { expect(build(:device)).to be_valid }

  describe 'validations' do
    it { expect(build(:device, login: nil)).to be_invalid }
    it { expect(build(:device, password: nil)).to be_invalid }
  end
end
