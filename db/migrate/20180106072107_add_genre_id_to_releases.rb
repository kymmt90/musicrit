class AddGenreIdToReleases < ActiveRecord::Migration[5.2]
  def change
    add_reference :releases, :genre, foreign_key: true
  end
end
