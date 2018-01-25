class Track < ApplicationRecord
  alias_attribute :name, :title

  belongs_to :release

  has_many :reviews, as: :reviewable, dependent: :destroy

  validates :description, length: { minimum: 0, allow_nil: false }
  validates :disc_number, numericality: { greater_than: 0, only_integer: true }
  validates :title, presence: true
  validates :track_number, numericality: { greater_than: 0, only_integer: true }, uniqueness: { scope: :release }
end
