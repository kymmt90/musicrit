class Genre < ApplicationRecord
  has_many :genre_releases, dependent: :restrict_with_exception
  has_many :releases, through: :genre_releases

  validates :description, length: { minimum: 0 }, allow_nil: false
  validates :name, presence: true, uniqueness: true
end
