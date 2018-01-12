FactoryBot.define do
  factory :user do
    email { FFaker::Internet.free_email }
    password { FFaker::Internet.password }
  end
end
