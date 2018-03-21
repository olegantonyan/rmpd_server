FactoryBot.define do
  factory :news_item do
    title { Faker::Hacker.say_something_smart }
    body { Faker::Lorem.paragraph }
  end
end
