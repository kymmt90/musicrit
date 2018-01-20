FactoryBot.define do
  factory :review do
    body { FFaker::Lorem.paragraphs.join(' ') }
    reviewable { build(:musician) }
    user

    trait :for_musician do
      # do nothing
    end

    trait :for_release do
      reviewable { build(:release) }
    end

    trait :for_track do
      reviewable { build(:track) }
    end
  end
end
