class Release < ApplicationRecord
  belongs_to :musician

  has_many :tracks, dependent: :destroy

  validates :description, length: { minimum: 0, allow_nil: false }
  validates :released_on, format: { with: /\A[1-9]\d{0,3}-\d\d-\d\d\z/ }, presence: true
  validates :title, presence: true, uniqueness: { scope: [:musician, :released_on] }
end
