FactoryBot.define do
  factory :musician do
    name { FFaker::Music.artist }
    begun_in { (1..2020).to_a.sample.to_s }
    description { FFaker::Lorem.paragraphs }
  end
end
