FactoryBot.define do
  factory :user do
    email { Faker::Internet.email }
    password { Faker::Internet.password(8) }

    factory :user_root do
      root { true }
    end
  end
end
