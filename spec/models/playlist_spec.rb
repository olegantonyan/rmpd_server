require 'rails_helper'

RSpec.describe Playlist, type: :model do
  it { expect(build(:playlist)).to be_valid }

  describe 'validations' do
    it { expect(build(:playlist, name: nil)).to be_invalid }
  end
end
