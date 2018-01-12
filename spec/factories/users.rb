FactoryBot.define do
  factory :user do
    authentications
    email { FFaker::Internet.free_email }
    password { FFaker::Internet.password }
  end
end
