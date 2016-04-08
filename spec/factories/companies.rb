FactoryGirl.define do
  factory :company do
    title { Faker::Company.name }
  end
end
