class CreateAlbums < ActiveRecord::Migration[5.2]
  def change
    create_table :albums do |t|
      t.string :title, null: false
      t.text :description, default: ''
      t.date :released_on, null: false
      t.references :musician, foreign_key: true

      t.timestamps
    end

    add_index :albums, [:musician_id, :title, :released_on], unique: true
  end
end
