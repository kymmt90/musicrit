class Review < ApplicationRecord
  belongs_to :reviewable, polymorphic: true
  belongs_to :musician, -> { joins(:reviews).where(reviews: { reviewable_type: 'Musician' }) }, foreign_key: 'reviewable_id', optional: true
  belongs_to :release, -> { joins(:reviews).where(reviews: { reviewable_type: 'Release' }) }, foreign_key: 'reviewable_id', optional: true
  belongs_to :track, -> { joins(:reviews).where(reviews: { reviewable_type: 'Track' }) }, foreign_key: 'reviewable_id', optional: true
  belongs_to :user

  validates :body, presence: true
end
