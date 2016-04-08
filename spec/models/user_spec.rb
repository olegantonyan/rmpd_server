require 'rails_helper'

RSpec.describe User, type: :model do
  it { expect(build(:user)).to be_valid }

  describe 'validations' do
    it { expect(build(:user, email: nil)).to be_invalid }
    it { expect(build(:user, password: nil)).to be_invalid }
  end
end
