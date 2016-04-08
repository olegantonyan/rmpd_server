require 'rails_helper'

RSpec.describe Playlist::Item, type: :model do
  it { expect(build(:playlist_item)).to be_valid }

  describe 'validations' do
    it { expect(build(:playlist_item, playlist: nil)).to be_invalid }
    it { expect(build(:playlist_item, media_item: nil)).to be_invalid }
  end
end
