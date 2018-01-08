class GenreRelease < ApplicationRecord
  belongs_to :genre
  belongs_to :release
end
