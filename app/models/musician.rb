class Musician < ApplicationRecord
  has_many :releases, dependent: :destroy
  has_many :reviews, as: :reviewable, dependent: :destroy

  validates :begun_in, format: { with: /\A[1-9]\d{0,3}\z/ }, presence: true
  validates :description, length: { minimum: 0, allow_nil: false }
  validates :name, presence: true
end
