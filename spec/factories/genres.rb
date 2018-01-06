FactoryBot.define do
  factory :genre do
    sequence(:name) { |n| "#{FFaker::Music.genre}#{n}" }
    description { FFaker::Lorem.paragraphs.join(' ') }
  end
end
