FactoryBot.define do
  factory :track do
    release
    title { FFaker::Music.song }
    sequence(:disc_number)
    sequence(:track_number)
    description { FFaker::Lorem.paragraphs.join(' ') }
  end
end
