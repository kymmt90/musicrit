class CreateGenreReleases < ActiveRecord::Migration[5.2]
  def change
    create_table :genre_releases do |t|
      t.references :genre, foreign_key: true
      t.references :release, foreign_key: true

      t.timestamps
    end
  end
end
