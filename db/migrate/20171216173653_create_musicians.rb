class CreateMusicians < ActiveRecord::Migration[5.2]
  def change
    create_table :musicians do |t|
      t.string :name, null: false
      t.string :begun_in, null: false
      t.text :description, null: false

      t.timestamps
    end

    add_index :musicians, [:name, :begun_in]
  end
end
