require 'rails_helper'

RSpec.describe Invite::Accept, type: :service do
  describe 'validations' do
    it { expect(build(:invite_accept, user: nil)).to be_invalid }
    it { expect(build(:invite_accept, invite: nil)).to be_invalid }

    it do
      invited_user = create(:user)
      invite = create(:invite, email: invited_user.email)
      accept = build(:invite_accept, user: invited_user, invite: invite)
      expect(accept).to be_valid
    end

    it do
      invited_user = create(:user)
      invite = create(:invite)
      accept = build(:invite_accept, user: invited_user, invite: invite)
      expect(accept).to be_invalid
    end

    it do
      invited_user = create(:user)
      company = create(:company)
      invited_user.companies << company
      invite = create(:invite, email: invited_user.email, company: company)
      accept = build(:invite_accept, user: invited_user, invite: invite)
      expect(accept).to be_invalid
    end
  end
end
