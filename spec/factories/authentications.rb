FactoryBot.define do
  factory :authentication do
    encrypted_auth_hash { SecureRandom.base64 }
    provider { %w(facebook github twitter).sample }
    uid { rand(100000).to_s }
    user
  end
end
