class NewReviewsTable < ActiveRecord::Migration[5.2]
  def change
    create_table :reviews do|t|
      t.float :rating
      t.string :comment
    end
    add_reference :reviews , :profile , index:true
    add_foreign_key :reviews , :profiles
  end
end
