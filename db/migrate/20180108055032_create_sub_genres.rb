class CreateSubGenres < ActiveRecord::Migration[5.2]
  def change
    create_table :sub_genres do |t|
      t.string :name, null: false
      t.text :description, null: false
      t.references :genre, foreign_key: true

      t.timestamps
    end

    add_index :sub_genres, :name, unique: true
  end
end
