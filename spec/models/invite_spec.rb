require 'rails_helper'

RSpec.describe Invite, type: :model do
  it { expect(build(:invite)).to be_valid }
end
