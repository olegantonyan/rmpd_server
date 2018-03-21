FactoryBot.define do
  factory :company do
    title { Faker::Company.name + '___' + SecureRandom.hex }
  end
end
