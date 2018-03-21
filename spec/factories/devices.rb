FactoryBot.define do
  factory :device do
    login { Faker::Internet.email }
    password { Faker::Internet.password(8) }
    name { Faker::Hacker.adjective }
    company
  end
end
