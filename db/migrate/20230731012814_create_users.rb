class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      t.string :first_name
      t.string :last_name
      t.string :email
      t.string :password_digest
      t.datetime :email_confirmed_at
      t.integer :role

      t.timestamps
    end
    add_index :users, :email, unique: true
    add_index :users, :email_confirmed_at
  end
end
