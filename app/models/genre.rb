class Genre < ApplicationRecord
  validates :description, length: { minimum: 0 }, allow_nil: false
  validates :name, presence: true, uniqueness: true
end
