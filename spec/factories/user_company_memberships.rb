FactoryGirl.define do
  factory :user_company_membership do
    title { Faker::Commerce.department }
    user
    company
  end
end
