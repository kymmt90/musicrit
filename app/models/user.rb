class User < ApplicationRecord
  devise :confirmable, :database_authenticatable, :recoverable, :registerable, :rememberable, :trackable, :validatable,
         :omniauthable, omniauth_providers: %i(facebook twitter)

  has_many :authentications, dependent: :destroy
  has_many :reviews, dependent: :destroy

  validates :name, format: /\A[a-zA-Z_]+\z/, length: { maximum: 15 }, presence: true

  def self.new_with_session(params, session)
    super.tap do |user|
      if auth_hash = session['devise.omniauth_data']
        user.password = Devise.friendly_token[0, 20]
        user.authentications << Authentication.from_omniauth(auth_hash)
        if auth_email = auth_hash.dig('info', 'email')
          user.email = auth_email if user.email.blank?
          user.confirmed_at = Time.current if user.email == auth_email
        end
      end
    end
  end
end
