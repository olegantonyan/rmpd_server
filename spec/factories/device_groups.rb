FactoryGirl.define do
  factory :device_group, class: 'Device::Group' do
    title { Faker::Lorem.sentence }
  end
end
