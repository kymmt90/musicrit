class Authentication < ApplicationRecord
  belongs_to :user

  validates :encrypted_auth_hash, presence: true
  validates :provider, presence: true
  validates :uid, presence: true, uniqueness: { scope: :provider }

  class << self
    def encryptor
      ActiveSupport::MessageEncryptor.new(Rails.application.credentials[:secret_encrypted_key])
    end
    delegate :encrypt_and_sign, :decrypt_and_verify, to: :encryptor

    def from_omniauth(auth)
      auth_hash = auth.to_h
      find_or_initialize_by(auth_hash.slice('provider', 'uid')) do |authentication|
        authentication.auth_hash = auth_hash
      end
    end
  end

  def auth_hash
    Authentication.decrypt_and_verify(encrypted_auth_hash)
  end

  def auth_hash=(value)
    self.encrypted_auth_hash = Authentication.encrypt_and_sign(value)
  end
end
