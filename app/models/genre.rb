class Genre < ApplicationRecord
  has_many :releases, dependent: :restrict_with_exception

  validates :description, length: { minimum: 0 }, allow_nil: false
  validates :name, presence: true, uniqueness: true
end
