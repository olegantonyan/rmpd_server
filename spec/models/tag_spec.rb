require 'rails_helper'

RSpec.describe Tag, type: :model do
  it { expect(build(:tag)).to be_valid }

  describe 'validations' do
    it { expect(build(:tag, name: nil)).to be_invalid }
  end
end
