class AddingRelations < ActiveRecord::Migration[5.2]
  def change
    add_reference :transactions , :profile , index:true
    add_foreign_key :transactions , :profiles
  end
end
