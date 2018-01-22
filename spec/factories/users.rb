FactoryBot.define do
  factory :user do
    transient do
      available_name_chars { [('A'..'Z').to_a, ('a'..'z').to_a, '_'].flatten }
      name_length 15
    end

    email { FFaker::Internet.free_email }
    name { available_name_chars.sample(name_length).join }
    password { FFaker::Internet.password }
  end
end
