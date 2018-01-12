class User < ApplicationRecord
  devise :confirmable, :database_authenticatable, :recoverable, :registerable, :rememberable, :trackable, :validatable,
         :omniauthable, omniauth_providers: %i(twitter)

  has_many :authentications, dependent: :destroy
end
