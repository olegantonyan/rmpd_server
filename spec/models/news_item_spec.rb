require 'rails_helper'

RSpec.describe NewsItem, type: :model do
  it { expect(build(:news_item)).to be_valid }

  describe 'validations' do
    it { expect(build(:news_item, title: nil)).to be_invalid }
    it { expect(build(:news_item, body: '')).to be_invalid }
  end
end
