class CreatePosts < ActiveRecord::Migration[5.2]
  def change
    create_table :posts do |t|
      t.reference :user
      t.string :title
      t.text :descrption

      t.timestamps
    end
  end
end
