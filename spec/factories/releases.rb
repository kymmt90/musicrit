FactoryBot.define do
  factory :release do
    title { FFaker::Music.album }
    description { FFaker::Lorem.paragraphs.join(' ') }
    released_on { FFaker::Time.date }
    genre
    musician
  end
end
