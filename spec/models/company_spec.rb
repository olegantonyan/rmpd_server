require 'rails_helper'

RSpec.describe Company, type: :model do
  it { expect(build(:company)).to be_valid }

  describe 'validations' do
    it { expect(build(:company, title: nil)).to be_invalid }
  end
end
