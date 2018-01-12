class CreateAuthentications < ActiveRecord::Migration[5.2]
  def change
    create_table :authentications do |t|
      t.references :user, foreign_key: true
      t.string :provider, null: false
      t.string :uid, null: false
      t.text :encrypted_auth_hash, null: false

      t.timestamps
    end

    add_index :authentications, [:provider, :uid], unique: true
  end
end
