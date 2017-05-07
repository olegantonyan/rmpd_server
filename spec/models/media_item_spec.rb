require 'rails_helper'

RSpec.describe MediaItem, type: :model do
  it { expect(build(:media_item)).to be_valid }

  describe 'validations' do
    it { expect(build(:media_item, file: nil)).to be_invalid }
    it { expect(build(:media_item, company: nil)).to be_invalid }
  end

  describe 'taggings' do
    it {
      tags = [create(:tag), create(:tag), create(:tag)]
      media_item = create(:media_item, tags: tags)
      media_item.reload
      expect(media_item.tags.count).to eq 3
    }
  end
end
