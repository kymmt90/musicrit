class User < ApplicationRecord
  devise :confirmable, :database_authenticatable, :recoverable, :registerable, :rememberable, :trackable, :validatable
end
