class AddingDeviceColums < ActiveRecord::Migration[5.2]
  def change
      change_table(:profiles) do|t|
        t.string :encrypted_password, null: false, default: ""
        t.string  :reset_password_token
        t.datetime :remember_created_at
        # add new column but allow null values
        t.timestamps  null: true

        # backfill existing record with created_at and updated_at
        # values making clear that the records are faked
        long_ago = DateTime.new(2000, 1, 1)
        Profile.update_all(created_at: long_ago, updated_at: long_ago)

      end
      # change not null constraints
      change_column_null :profiles, :created_at, false
      change_column_null :profiles, :updated_at, false
      add_index :profiles, :email,                unique: true
      add_index :profiles, :reset_password_token, unique: true
    end
end
