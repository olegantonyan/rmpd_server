require 'rails_helper'

RSpec.describe CompanyPolicy, type: :policy do
  subject { described_class.new(user, object) }

  context 'for root' do
    let(:object) { create(:company) }
    let(:user) { create(:user_root) }

    pundit_permit(*%i(index show new edit create update destroy))
  end

  context 'for member of the company' do
    let(:object) { create(:company) }
    let(:user) { create(:user, companies: [object]) }

    pundit_permit(*%i(index show))
    pundit_forbid(*%i(new edit create update destroy))
  end

  context 'for everyone else' do
    let(:object) { create(:company) }
    let(:user) { create(:user) }

    pundit_forbid(*%i(create new edit update destroy show))
    pundit_permit(*%i(index))
  end

  describe 'scope' do
    let(:company_1) { create(:company) }
    let(:company_2) { create(:company) }
    let(:object_class) { Company }

    it 'returns all records to root' do
      expect(object_class.all).not_to be_empty
      pundit_policy_scope(create(:user_root), object_class.all, object_class.all)
    end

    it 'returns only belonging records to company' do
      pundit_policy_scope(create(:user, companies: [company_1]),
                          object_class.all,
                          object_class.where(title: [company_1.title, object_class.demo.title])
                          )
      pundit_policy_scope(create(:user, companies: [company_2]),
                          object_class.all,
                          object_class.where(title: [company_2.title, object_class.demo.title])
                          )
    end
  end
end
