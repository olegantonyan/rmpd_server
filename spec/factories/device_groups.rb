FactoryBot.define do
  factory :device_group, class: 'Device::Group' do
    title { Faker::Lorem.sentence }
    after :build do |g|
      g.devices << build(:device)
    end
  end
end
