FactoryBot.define do
  factory :list do
    name { Faker::Name.last_name }

    trait :soft_deleted do
      deleted_at { Time.zone.now }
    end
  end
end
