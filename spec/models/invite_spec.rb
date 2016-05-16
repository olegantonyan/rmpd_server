require 'rails_helper'

RSpec.describe Invite, type: :model do
  it { expect(build(:invite)).to be_valid }

  describe 'validations' do
    it { expect(build(:invite, company: nil)).to be_invalid }
    it { expect(build(:invite, user: nil)).to be_invalid }
    it { expect(build(:invite, email: nil)).to be_invalid }
  end

  it do
    expect(build(:invite).token).not_to be_nil
  end
end
