require 'rails_helper'

RSpec.describe MediaItem, type: :model do
  it { expect(build(:media_item)).to be_valid }

  describe 'validations' do
    it { expect(build(:media_item, file: nil)).to be_invalid }
    it { expect(build(:media_item, company: nil)).to be_invalid }
  end
end
