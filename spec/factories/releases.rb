FactoryBot.define do
  factory :release do
    title { FFaker::Music.song }
    description { FFaker::Lorem.paragraphs.join(' ') }
    released_on { FFaker::Time.date }
    musician
  end
end
