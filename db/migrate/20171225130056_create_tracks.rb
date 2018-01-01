class CreateTracks < ActiveRecord::Migration[5.2]
  def change
    create_table :tracks do |t|
      t.references :release, foreign_key: true, index: false
      t.string :title, null: false
      t.integer :disc_number, null: false
      t.integer :track_number, null: false
      t.text :description, default: '', null: false

      t.timestamps
    end

    add_index :tracks, [:release_id, :track_number], unique: true
  end
end
