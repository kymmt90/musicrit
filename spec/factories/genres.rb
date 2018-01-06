FactoryBot.define do
  factory :genre do
    name { FFaker::Music.genre }
    description { FFaker::Lorem.paragraphs.join(' ') }
  end
end
