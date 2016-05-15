FactoryGirl.define do
  factory :invite do
    email { Faker::Internet.email }
    token { Faker::Internet.password }
    company
    user
  end
end
