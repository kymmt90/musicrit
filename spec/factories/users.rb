FactoryBot.define do
  factory :user do
    email { FFaker::Internet.free_email }
    name { FFaker::Internet.user_name.gsub('.', '_') }
    password { FFaker::Internet.password }
  end
end
