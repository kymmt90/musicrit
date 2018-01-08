FactoryBot.define do
  factory :sub_genre do
    sequence(:name) { |n| "#{FFaker::Music.genre}#{n}" }
    description { FFaker::Lorem.paragraphs.join(' ') }
    genre
  end
end
