class CreatePosts < ActiveRecord::Migration[7.0]
  def change
    create_table :posts do |t|
      t.string :title
      t.string :text
      t.references :author, null: false, foreign_key: { to_table: :users }

      t.timestamps
    end
  end
end
