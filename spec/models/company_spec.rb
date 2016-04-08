require 'rails_helper'

RSpec.describe Company, type: :model do
  it { expect(build(:company)).to be_valid }

  it { expect(described_class.demo.title).to eq 'Demo' }

  describe 'validations' do
    it { expect(build(:company, title: nil)).to be_invalid }
  end
end
