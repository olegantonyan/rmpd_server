FactoryGirl.define do
  factory :playlist do
    name { Faker::Hacker.say_something_smart }
    description { Faker::Lorem.paragraph }
    company

    after(:build) do |pl|
      3.times { |i| pl.playlist_items << build(:playlist_item, playlist: pl, position: i) }
    end
  end
end
