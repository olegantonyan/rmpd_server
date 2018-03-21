FactoryBot.define do
  factory :device_group_membership, class: 'Device::Group::Membership' do
    description { Faker::Company.buzzword }
    device
    device_group
  end
end
