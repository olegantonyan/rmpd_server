FactoryBot.define do
  factory :user_registrations, class: 'User::Registration' do
    email { Faker::Internet.email }
    password { Faker::Internet.password(8) }
  end
end
