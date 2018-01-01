class Track < ApplicationRecord
  belongs_to :release

  validates :description, length: { minimum: 0, allow_nil: false }
  validates :disc_number, numericality: { greater_than: 0, only_integer: true }
  validates :title, presence: true
  validates :track_number, numericality: { greater_than: 0, only_integer: true }, uniqueness: { scope: :release }
end
