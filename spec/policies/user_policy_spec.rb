require 'rails_helper'

RSpec.describe UserPolicy, type: :policy do
  subject { described_class.new(user, object) }

  context 'for root' do
    let(:object) { create(:user) }
    let(:user) { create(:user_root) }

    pundit_permit(*%i[index show new edit create update destroy])
  end

  context 'for member of the company' do
    let(:company) { create(:company) }
    let(:object) { create(:user, companies: [company]) }
    let(:user) { create(:user, companies: [company]) }

    pundit_permit(*%i[show])
  end

  context 'for everyone else' do
    let(:object) { create(:user) }
    let(:user) do
      u = create(:user)
      u.companies = []
      u.save!
      u
    end

    pundit_forbid(*%i[index create new edit update destroy show])
  end
end
