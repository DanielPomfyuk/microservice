class CreatingUsersDb < ActiveRecord::Migration[5.2]
  def change
    create_table :profiles do |t|
      t.string :email
      t.string :password
      t.string :first_name
      t.string :last_name
      t.integer :phone_number
      t.integer :raters_quontity
      t.float :rating
    end
  end
end
