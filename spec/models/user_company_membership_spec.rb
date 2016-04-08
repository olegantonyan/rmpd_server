require 'rails_helper'

RSpec.describe UserCompanyMembership, type: :model do
  it { expect(build(:user_company_membership)).to be_valid }

  describe 'validations' do
    it { expect(build(:user_company_membership, user: nil)).to be_invalid }
    it { expect(build(:user_company_membership, company: nil)).to be_invalid }
  end
end
