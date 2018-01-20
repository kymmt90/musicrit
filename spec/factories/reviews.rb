FactoryBot.define do
  factory :review do
    body { FFaker::Lorem.paragraphs.join(' ') }
    user
  end
end
