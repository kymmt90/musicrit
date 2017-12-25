FactoryBot.define do
  factory :track do
    release
    title { FFaker::Music.song }
    disc_number { rand(1..10) }
    track_number { rand(1..20) }
  end
end
