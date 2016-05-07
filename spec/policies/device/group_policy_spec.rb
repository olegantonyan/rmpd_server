require 'rails_helper'

RSpec.describe Device::GroupPolicy, type: :policy do
  subject { described_class.new(user, object) }

  context 'for root' do
    let(:object) { create(:device_group) }
    let(:user) { create(:user_root) }

    pundit_permit(*%i(index show new edit create update destroy))
  end

  context 'for member of the company' do
    let(:object) { create(:device_group, devices: [create(:device)]) }
    let(:user) { create(:user, companies: [object.devices.sample.company]) }

    pundit_permit(*%i(index show new edit create update destroy))
  end

  context 'for everyone else' do
    let(:object) { create(:device_group) }
    let(:user) { create(:user) }

    pundit_forbid(*%i(edit update destroy show))
    pundit_permit(*%i(index create new))
  end

  describe 'scope' do
    before :each do
      5.times { create(:device_group, devices: [device_1]) }
      5.times { create(:device_group, devices: [device_2]) }
    end

    let(:device_1) { create(:device) }
    let(:device_2) { create(:device) }
    let(:object_class) { Device::Group }

    it 'returns all records to root' do
      expect(object_class.all).not_to be_empty
      pundit_policy_scope(create(:user_root), object_class.all, object_class.all)
    end

    it 'returns only belonging records to company' do
      pundit_policy_scope(create(:user, companies: [device_1.company]), object_class.all, object_class.joins(:devices).where(devices: { company: device_1.company }))
      pundit_policy_scope(create(:user, companies: [device_2.company]), object_class.all, object_class.joins(:devices).where(devices: { company: device_2.company }))
    end
  end
end
