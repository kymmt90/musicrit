class CreateReleases < ActiveRecord::Migration[5.2]
  def change
    create_table :releases do |t|
      t.string :title, null: false
      t.text :description, null: false, default: ''
      t.date :released_on, null: false
      t.references :musician, foreign_key: true, index: false

      t.timestamps
    end

    add_index :releases, [:musician_id, :title, :released_on], unique: true
  end
end
