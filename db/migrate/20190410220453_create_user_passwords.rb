class CreateUserPasswords < ActiveRecord::Migration[5.2]
  def change
    create_table :user_passwords do |t|
      t.reference :user
      t.string :password

      t.timestamps
    end
  end
end
