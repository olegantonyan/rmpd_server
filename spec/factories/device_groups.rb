FactoryGirl.define do
  factory :device_group, class: 'Device::Group' do
    title { Faker::Hacker.noun }
  end
end
