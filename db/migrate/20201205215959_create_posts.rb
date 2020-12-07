class CreatePosts < ActiveRecord::Migration[6.0]
  def change
    create_table :posts do |t|
      t.text :rank1, null: false
      t.text :rank2, null: false
      t.text :rank3, null: false
      t.string :title, null: false
      t.references  :user,     foreign_key: true

      t.timestamps
    end
  end
end
