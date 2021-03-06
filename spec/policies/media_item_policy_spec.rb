require 'rails_helper'

RSpec.describe MediaItemPolicy, type: :policy do
  subject { described_class.new(user, object) }

  context 'for root' do
    let(:object) { create(:media_item) }
    let(:user) { create(:user_root) }

    pundit_permit(*%i[index show new edit create update destroy])
  end

  context 'for member of the company' do
    let(:object) { create(:media_item) }
    let(:user) { create(:user, companies: [object.company]) }

    pundit_permit(*%i[index show new edit create update destroy])
  end

  context 'for everyone else' do
    let(:object) { create(:media_item) }
    let(:user) { create(:user) }

    pundit_forbid(*%i[edit update destroy show create])
    pundit_permit(*%i[index new])
  end

  describe 'scope' do
    before :each do
      5.times { create(:media_item, company: company_1) }
      5.times { create(:media_item, company: company_2) }
    end

    let(:company_1) { create(:company) }
    let(:company_2) { create(:company) }
    let(:object_class) { MediaItem }

    it 'returns all records to root' do
      expect(object_class.all).not_to be_empty
      pundit_policy_scope(create(:user_root), object_class.all, object_class.all)
    end

    it 'returns only belonging records to company' do
      pundit_policy_scope(create(:user, companies: [company_1]), object_class.all, object_class.where(company: company_1))
      pundit_policy_scope(create(:user, companies: [company_2]), object_class.all, object_class.where(company: company_2))
    end
  end
end
